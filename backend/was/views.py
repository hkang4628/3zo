from django.http import JsonResponse
from django.utils.encoding import smart_str
from django.utils import timezone
from .models import Member, Contest

import json
import socket

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

        return JsonResponse({'result': "success"})
    return JsonResponse({'result': "fail"})
