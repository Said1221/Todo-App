

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit.dart';
import 'package:todo_app/new_screen.dart';

Widget buildTaskItems(Map model , context)=> Dismissible(
  // key: Key(model['id'].toString()),
      child : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [

            CircleAvatar(
              radius: 40,
              child: Text('${model['time']}'),
            ),

            SizedBox(
              width: 10,
            ),

            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${model['title']}'),
                  Text('${model['date']}',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  ),
                ],
              ),
            ),

            IconButton(onPressed:(){
              AppCubit.get(context).updateDatabase(
                  status: 'done',
                  id: model['id'],
              );
            },
              icon: Icon(
                Icons.check_box,
                color: Colors.green,
              ),
            ),


            IconButton(onPressed:(){
              AppCubit.get(context).updateDatabase(
                  status: 'archieve',
                  id: model['id'],
              );
            },
              icon: Icon(
                Icons.archive_outlined,
              ),),

            IconButton(onPressed:(){
              AppCubit.get(context).deleteDatabase(
                  id: model['id'],
              );
            },
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),),
          ],
        ),
      ),
);


Widget taskBuilder ({
  @required List<Map>tasks ,
}) => ConditionalBuilder(
    condition: tasks.length>0,
    builder: (context) => ListView.separated(
        itemBuilder: (context , index){
          return buildTaskItems(tasks[index] , context);
        },
      separatorBuilder: (context , index) => myDivider(),
      itemCount: tasks.length,
    ),
    fallback: (context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu,
            size: 80,
          ),
          Text('No Tasks yet , please add some Tasks',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
    ),
);






Widget myDivider() => Padding(
  padding: const EdgeInsetsDirectional.only(
    start: 20.0,
  ),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[300],
  ),
);

