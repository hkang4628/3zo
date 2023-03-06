from django.db import models


class Member(models.Model):
    member_id = models.CharField(max_length=20, null=False)
    member_pw = models.CharField(max_length=20, null=False)
    member_name = models.CharField(max_length=20, null=False)
    member_phone = models.CharField(max_length=20, null=False)
    member_email = models.EmailField()

    def __str__(self):
        return self.member_id


class Contest(models.Model):
    title = models.CharField(max_length=20, null=False)
    member_name = models.CharField(max_length=20, null=False)
    member_id = models.CharField(max_length=20, null=False)
    location = models.CharField(max_length=20, null=False)
    thumbnail = models.URLField()
    img_url = models.URLField()

    def __str__(self):
        return self.title
