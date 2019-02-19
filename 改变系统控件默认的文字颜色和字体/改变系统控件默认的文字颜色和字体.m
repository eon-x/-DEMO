
改变UIAlertController的标题、内容的字体和颜色
https://www.jianshu.com/p/51949eec2e9c

修改textField的placeholder的字体颜色、大小
textField.placeholder = @"username is in here!";
[textField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
[textField setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];



