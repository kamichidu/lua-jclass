require 'youjo'

print(youjo.pretty({1, 2, 3}))
print(youjo.pretty({a= 'a', b= 3, c= {1, 2, 3}}))
print(youjo.pretty({
    [1]= 3,
    [2]= 4,
    a= 'hoge',
}))
print(youjo.pretty(1))
print(youjo.pretty('1'))
