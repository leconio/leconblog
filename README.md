# 部署说明
1. 首先注释自定义的auth模块
2. 执行`python manage.py migrate`
3. 取消注释`python manage.py migrate`
4.
```shell

python manage.py makemigrations --empty blog
python manage.py makemigrations --empty _admin
python manage.py makemigrations --empty _auth
python manage.py makemigrations --empty _email
python manage.py makemigrations --empty comments
python manage.py makemigrations
`python manage.py migrate`

```