# kwargs.pop()

```py
def hello(**kwargs):
    print (kwargs)
    #{'husband': 'yu', 'sex': 'nv', 'name': 'zhaojinye'}
    m = kwargs.pop("age","22")
    print (m , kwargs)
    #22
    # {'husband': 'yu', 'sex': 'nv', 'name': 'zhaojinye'}
def hello1(**kwargs):
    print(kwargs)
    # {'husband': 'yu', 'sex': 'nv', 'name': 'zhaojinye'}
    m = kwargs.pop('name')
    print(m, kwargs)
    # zhaojinye
    # {'husband': 'yu', 'sex': 'nv'}
def hello2(**kwargs):
    print(kwargs)
    # {'husband': 'yu', 'sex': 'nv', 'name': 'zhaojinye'}
    m = kwargs.pop("name","yushilin")
    print(m, kwargs)
    # zhaojinye
    # {'husband': 'yu', 'sex': 'nv'}
hello(name='zhaojinye' ,sex = "nv",husband = "yu")
hello1(name='zhaojinye' ,sex = "nv",husband = "yu")
hello2(name='zhaojinye' ,sex = "nv",husband = "yu")

```

