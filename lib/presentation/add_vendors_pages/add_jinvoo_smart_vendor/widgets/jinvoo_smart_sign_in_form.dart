import 'package:another_flushbar/flushbar_helper.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cybear_jinni/application/tuya_auth/tuya_sign_in_form/tuya_sign_in_form_bloc.dart';
import 'package:cybear_jinni/domain/vendors/login_abstract/core_login_failures.dart';
import 'package:cybear_jinni/infrastructure/core/gen/cbj_hub_server/protoc_as_dart/cbj_hub_server.pbgrpc.dart';
import 'package:cybear_jinni/presentation/routes/app_router.gr.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class JinvooSmartSignInForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return BlocConsumer<TuyaSignInFormBloc, TuyaSignInFormState>(
      listener: (context, state) {
        state.authFailureOrSuccessOption.fold(
          () {},
          (Either<CoreLoginFailure, Unit> either) => either.fold(
              (CoreLoginFailure failure) => {
                    FlushbarHelper.createError(
                      message: 'Validation error',
                      // failure.map(
                      //   cancelledByUser: (_) => 'Cancelled',
                      //   serverError: (_) => 'Server error',
                      //   invalidApiKey: (_) => 'Email already in use',
                      // ),
                    ).show(context),
                  }, (_) {
            context.router.push(const WhereToLoginRouteMinimalRoute());

            // context
            //     .read()<TuyaSignInFormBloc>()
            //     .add(const TuyaSignInFormEvent.());
          }),
        );
      },
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: [
                    Hero(
                      tag: 'Logo',
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: screenSize.height * 0.1,
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                'https://play-lh.googleusercontent.com/ocFF7mcDTJzr1PXr6k4q1Q2-5xNFUVODqluwnD60DiTsHgTalrVTqi7kk0H8JnW7GLEv=s180',
                              ),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                        // Image.asset('assets/cbj_logo.png'),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        prefixIcon: FaIcon(FontAwesomeIcons.signInAlt),
                        labelText: 'Jinvoo Smart User Name',
                      ),
                      autocorrect: false,
                      onChanged: (value) => context
                          .read<TuyaSignInFormBloc>()
                          .add(TuyaSignInFormEvent.userNameChanged(value)),
                      validator: (_) => context
                          .read<TuyaSignInFormBloc>()
                          .state
                          .tuyaUserName
                          .value
                          .fold(
                            (CoreLoginFailure f) => 'Validation error',
                            //   f.maybeMap(
                            // invalidEmail: (result) => result.failedValue,
                            // containsSpace: (result) => result.failedValue,
                            // orElse: () => null,
                            // ),
                            (r) => null,
                          ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        prefixIcon: FaIcon(FontAwesomeIcons.unlock),
                        labelText: 'Jinvoo Smart User Password',
                      ),
                      autocorrect: false,
                      onChanged: (value) => context
                          .read<TuyaSignInFormBloc>()
                          .add(TuyaSignInFormEvent.userPasswordChanged(value)),
                      validator: (_) => context
                          .read<TuyaSignInFormBloc>()
                          .state
                          .tuyaUserPassword
                          .value
                          .fold(
                            (CoreLoginFailure f) => 'Validation error',
                            //   f.maybeMap(
                            // invalidEmail: (result) => result.failedValue,
                            // containsSpace: (result) => result.failedValue,
                            // orElse: () => null,
                            // ),
                            (r) => null,
                          ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        prefixIcon: FaIcon(FontAwesomeIcons.flag),
                        labelText: 'Jinvoo Smart Country Code',
                      ),
                      autocorrect: false,
                      onChanged: (value) => context
                          .read<TuyaSignInFormBloc>()
                          .add(TuyaSignInFormEvent.countryCodeChanged(value)),
                      validator: (_) => context
                          .read<TuyaSignInFormBloc>()
                          .state
                          .tuyaCountryCode
                          .value
                          .fold(
                            (CoreLoginFailure f) => 'Validation error',
                            //   f.maybeMap(
                            // invalidEmail: (result) => result.failedValue,
                            // containsSpace: (result) => result.failedValue,
                            // orElse: () => null,
                            // ),
                            (r) => null,
                          ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text('Select Region:        '),
                    DropdownButton<String>(
                      value: context
                          .read<TuyaSignInFormBloc>()
                          .state
                          .tuyaLoginRegion
                          .getOrCrash(),
                      icon: const Icon(Icons.arrow_drop_down),
                      hint: const Text('Jinvoo Smart Region'),
                      elevation: 16,
                      underline: Container(
                        height: 2,
                      ),
                      onChanged: (value) => context
                          .read<TuyaSignInFormBloc>()
                          .add(TuyaSignInFormEvent.regionChanged(value)),
                      items: <String>[
                        'us',
                        'eu',
                        'cn',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              context.read<TuyaSignInFormBloc>().add(
                                    TuyaSignInFormEvent.vendorChanged(
                                      VendorsAndServices.jinvooSmart.name
                                          .toString(),
                                    ),
                                  );
                              context.read<TuyaSignInFormBloc>().add(
                                    const TuyaSignInFormEvent.signIn(),
                                  );

                              Fluttertoast.showToast(
                                msg: 'Sign in to Jinvoo Smart, please restart '
                                    'the app to see the new devices',
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.indigo,
                                textColor: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                                fontSize: 16.0,
                              );
                              Navigator.pop(context);
                            },
                            child: const Text('SIGN IN').tr(),
                          ),
                        ),
                      ],
                    ),
                    if (state.isSubmitting) ...[
                      const SizedBox(
                        height: 8,
                      ),
                      const LinearProgressIndicator()
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}