import 'package:flutter/material.dart';
import 'text_field_container.dart';

class UsernameInputField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const UsernameInputField({
    Key? key,
    required this.onChanged,
    
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        decoration: const InputDecoration(
          icon: Icon(
            Icons.person, 
            color: Colors.black,
          ),
          hintText: "Username",
          border: InputBorder.none
        ) ,
      ), 
    );
  }
}
class EmailInputField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const EmailInputField({
    Key? key,
    required this.onChanged,
    
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        decoration: const InputDecoration(
          icon: Icon(
            Icons.person, 
            color: Colors.black,
          ),
          hintText: "Email",
          border: InputBorder.none
        ) ,
      ), 
    );
  }
}
