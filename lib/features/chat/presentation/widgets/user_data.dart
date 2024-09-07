import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/view_model/auth_cubit.dart';

class UpdateUserData extends StatelessWidget {
  const UpdateUserData({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) {
        return AuthCubit()..getUser();
      },
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {},
        child: const SizedBox.shrink(),
      ),
    );
  }
}
