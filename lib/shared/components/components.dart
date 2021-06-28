import 'package:flutter/material.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

import 'package:todo_app/shared/network/local/database_constants.dart';

Widget buildTextForm({
  required String hint,
  required TextEditingController controller,
  required IconData icon,
  required String? Function(String?) validator,
  Function()? onPress,
  TextInputType keyboardType = TextInputType.text,
  bool hideText = false,
  bool readOnly = false,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: hideText,
      onTap: onPress,
      readOnly: readOnly,
      validator: validator,
      decoration: InputDecoration(
        labelText: hint,
        prefixIcon: Icon(icon),
        enabledBorder: OutlineInputBorder(borderSide: const BorderSide()),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue)),
      ),
    );

Widget listItem({
  required BuildContext context,
  required Map<String, dynamic> todoItem,
  required IconData icon1,
  required Function() onPressicon1,
  required IconData icon2,
  required Function() onPressicon2,
}) {
  return Dismissible(
    onDismissed: (dir) {
      AppCubit.getInstance(context)
          .deleteItem(todoItem['${DatabaseConstants.COLUMN_ID}']);
    },
    key: Key(todoItem['${DatabaseConstants.COLUMN_ID}'].toString()),
    child: Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 16.0,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            child: Center(
              child: Text(
                todoItem['${DatabaseConstants.COLUMN_TIME}']
                        .toString()
                        .substring(0, 5) +
                    '\n ' +
                    todoItem['${DatabaseConstants.COLUMN_TIME}']
                        .toString()
                        .substring(5),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
            ),
            backgroundColor: Colors.blue[400],
          ),
          SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todoItem['${DatabaseConstants.COLUMN_TITLE}'][0]
                          .toString()
                          .toUpperCase() +
                      todoItem['${DatabaseConstants.COLUMN_TITLE}']
                          .toString()
                          .substring(1),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Text(
                  todoItem['${DatabaseConstants.COLUMN_DATE}'].toString(),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: onPressicon1,
            child: Icon(
              icon1,
              color: Colors.green,
              size: 32,
            ),
          ),
          SizedBox(
            width: 8.0,
          ),
          GestureDetector(
            onTap: onPressicon2,
            child: Icon(
              icon2,
              color: Color(0xff0F3253),
              size: 32,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildList(
    {required BuildContext context,
    required List tasksType,
    bool isNew = false,
    bool isDone = false}) {
  return ListView.separated(
    itemBuilder: (context, index) {
      return listItem(
        context: context,
        todoItem: tasksType[index],
        icon1: isNew ? Icons.check_circle : Icons.add_circle_rounded,
        onPressicon1: () {
          Todo todo = Todo.fromMap(tasksType[index]);
          if (isNew) {
            todo.status = 'done';
          } else {
            todo.status = 'new';
          }
          AppCubit.getInstance(context).updateItem(todo);
        },
        icon2: !isDone && !isNew ? Icons.check_circle : Icons.archive,
        onPressicon2: () {
          Todo todo = Todo.fromMap(tasksType[index]);
          if (!isDone && !isNew) {
            todo.status = 'done';
          } else {
            todo.status = 'archived';
          }
          AppCubit.getInstance(context).updateItem(todo);
        },
      );
    },
    separatorBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          //color: Colors.black,
          height: 2,
        ),
      );
    },
    itemCount: tasksType.length,
  );
}
