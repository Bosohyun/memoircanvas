import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memoircanvas/core/extensions/context_extension.dart';
import 'package:memoircanvas/core/services/injection_container.dart';
import 'package:memoircanvas/core/views/page_under_construction.dart';
import 'package:memoircanvas/src/auth/data/models/user_model.dart';
import 'package:memoircanvas/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:memoircanvas/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:memoircanvas/src/on_boarding/presentation/cubit/on_boarding_cubit.dart';
import 'package:memoircanvas/src/on_boarding/presentation/views/on_boarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../src/auth/presentation/views/sign_in_screen.dart';

part 'router.main.dart';
