-- vim: ft=lua
require '../parser'
require '../youjo'

print('B is'                   , parser.parse_field_descriptor('B'))
print('C is'                   , parser.parse_field_descriptor('C'))
print('D is'                   , parser.parse_field_descriptor('D'))
print('F is'                   , parser.parse_field_descriptor('F'))
print('I is'                   , parser.parse_field_descriptor('I'))
print('J is'                   , parser.parse_field_descriptor('J'))
print('Ljava/lang/Object; is'  , parser.parse_field_descriptor('Ljava/lang/Object;'))
print('S is'                   , parser.parse_field_descriptor('S'))
print('Z is'                   , parser.parse_field_descriptor('Z'))
print('[Ljava/lang/Object; is' , parser.parse_field_descriptor('[Ljava/lang/Object;'))
print('[[Ljava/lang/Object; is', parser.parse_field_descriptor('[[Ljava/lang/Object;'))

print('()V', youjo.pretty(parser.parse_method_descriptor('()V')))
print('(I)V', youjo.pretty(parser.parse_method_descriptor('(I)V')))
print('(IDLjava/lang/Thread;)Ljava/lang/Object;', youjo.pretty(parser.parse_method_descriptor('(IDLjava/lang/Thread;)Ljava/lang/Object;')))
