from django.http import JsonResponse
from django.utils.encoding import smart_str
from django.utils import timezone
from .models import Member, Contest

import json
import socket
import ftplib
import os
from .models import Contest


def health_check(request):
    hostname = socket.gethostname()

    return JsonResponse({'result': 'success', 'hostname': hostname})


def signup(request):
    if request.method == "POST":
        data = json.loads(request.body)
        id = data['id']
        pw = data['pw']
        name = data['name']
        phone = data['phone']
        email = data['email']

    if Member.objects.filter(member_id=id).exists():
        return JsonResponse({'result': "fail", 'message': 'The ID is already in use'}, status=200)

    Member(
        member_id=id,
        member_pw=pw,
        member_name=name,
        member_phone=phone,
        member_email=email,
    ).save()

    return JsonResponse({'result': "success"})


def login(request):
    if request.method == "POST":
        data = json.loads(request.body)
        id = data['id']
        pw = data['pw']

        member = Member.objects.filter(member_id=id, member_pw=pw).first()

        if member:
            memberInfo = Member.objects.values(
                'member_id', 'member_name', 'member_phone', 'member_email').get(member_id=id)

            memberInfo['result'] = "success"

            return JsonResponse(memberInfo)
        else:

            return JsonResponse({'result': "fail", 'message': "아이디 또는 비밀번호를 확인하세요"})


def contest_detail(request):
    id = request.GET.get('id')

    contest = Contest.objects.values(
        'id', 'title', 'member_name', 'thumbnail', 'img_url', 'location').get(id=id)

    if contest:
        contest['result'] = "success"
        print(contest)
        return JsonResponse(contest)
    else:
        return JsonResponse({'result': "fail"}, safe=False)


def contest_list(request):
    contests = Contest.objects.all()
    print(contests)
    contest_list = []
    for contest in contests:
        contest_list.append({
            'id': contest.id,
            'title': contest.title,
            'member_name': contest.member_name,
            'member_id': contest.member_id,
            'thumbnail': contest.thumbnail,
            'img_url': contest.img_url,
            'location': contest.location,
        })

    response = JsonResponse(contest_list, safe=False)
    response['content-type'] = 'application/json; charset=utf-8'
    response.content = smart_str(
        response.content, encoding='utf-8', strings_only=True)
    return response


def upload_file_to_ftp_server(file, ftp_server, ftp_username, ftp_password, ftp_directory, filename):
    # FTP 서버에 연결
    ftp = ftplib.FTP(ftp_server)

    ftp.login(ftp_username, ftp_password)

    # 파일 읽어오기 : 접속 확인용
    print(ftp.dir())
    print(file)

    # 파일을 이진 모드로 열어서 FTP 서버에 전송
    with open(file, 'rb') as f:
        ftp.cwd(ftp_directory)
        ftp.storbinary('STOR ' + filename, f)

    # FTP 연결 해제
    ftp.quit()


def upload(request):
    if request.method == "POST":

        title = request.POST['title']
        location = request.POST['location']
        member_id = request.POST['member_id']
        member_name = request.POST['member_name']
        phone = request.POST['phone']
        email = request.POST['email']
        image = request.FILES['image']

        # 이미지 파일의 content_type 속성을 사용하여 확장자를 추출합니다.
        extension = image.content_type.split('/')[-1]

        # 현재 시간을 기준으로 timestamp 생성
        timestamp = timezone.now().strftime('%Y%m%d%H%M%S')

        # email @ 치환 (s3 저장용)
        re_email = email.replace("@", "-")

        # 이미지 파일을 로컬 디스크에 저장
        filename = f'{timestamp}.{extension}'
        e_filename = f'{re_email}-{filename}'
        
        file_path = f'./img_temp/{image.name}'
        with open(file_path, 'wb') as f:
            for chunk in image.chunks():
                f.write(chunk)

        # 이미지 파일을 FTP 서버에 전송
        upload_file_to_ftp_server(
            file_path, '192.168.0.110', 'test', 'test', '/origin', e_filename)

        # # 로컬 디스크에 저장된 이미지 파일 삭제
        os.remove(file_path)

        # 업로드 성공 시 DB에도 정보 저장
        Contest(title=title, member_name=member_name, member_id=member_id, location=location,
                thumbnail=f'ThumbnailImage-{filename}', img_url=f'Resized-{filename}').save()

        return JsonResponse({'result': "success"})
    return JsonResponse({'result': "fail"})
