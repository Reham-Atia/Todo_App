import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/layout/todo_layout.dart';
import 'package:todo_app/shared/bloc_observer.dart';

void main()
{
  Bloc.observer = MyBlocObserver();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}
