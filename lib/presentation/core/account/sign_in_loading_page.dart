import 'package:check_in_application/check_in_application.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SignInAuth {

  static late UserProfileModel? currentUser = null;

  static void didSignInSuccessfully(BuildContext context, {required Function(UserProfileModel) currentUser}) {

    Navigator.push(context, MaterialPageRoute(
        builder: (_) {
          return BlocProvider(create: (_) => getIt<UserProfileWatcherBloc>()..add(const UserProfileWatcherEvent.watchUserProfileStarted()),
            child: BlocBuilder<UserProfileWatcherBloc, UserProfileWatcherState>(
              builder: (context, authState) {
                return authState.maybeMap(
                  loadInProgress: (_) => loadingConfirmReservation(),
                  loadProfileFailure: (_) => Container(
                    child: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  loadUserProfileSuccess: (item) {
                    return Container(
                      child: IconButton(
                        icon: Icon(Icons.check_circle),
                        onPressed: () {
                          SignInAuth.currentUser = item.profile;
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  },
                  orElse: () => Container(
                    child: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                );
              },
            ),
          );
        }
      )
    );
  }
}


class LoadingProgressSignIn extends StatefulWidget {
  const LoadingProgressSignIn({super.key});

  @override
  State<LoadingProgressSignIn> createState() => _LoadingProgressSignInState();
}

class _LoadingProgressSignInState extends State<LoadingProgressSignIn> {

  @override
  void initState() {
    Future.delayed(Duration(seconds: 7), () {
      setState(() {
        Navigator.of(context).pop();
        SignInAuth.didSignInSuccessfully(
            context,
            currentUser: (e) {

        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      color: Colors.red,
    );
  }
}

