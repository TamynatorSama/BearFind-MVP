import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:lost_items/controller/repository/auth_repo.dart';
import 'package:lost_items/pages/select_action.dart';
import 'package:lost_items/reusables/app_padding_wrapper.dart';
import 'package:lost_items/reusables/custom_btn.dart';
import 'package:lost_items/reusables/custom_textfield.dart';
import 'package:lost_items/reusables/expandable_scrollable_widget.dart';
import 'package:lost_items/utils/app_theme.dart';

class EmailWidget extends StatefulWidget {
  const EmailWidget({super.key});

  @override
  State<EmailWidget> createState() => _EmailWidgetState();
}

class _EmailWidgetState extends State<EmailWidget> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppPaddingWrapper(
        child: ExpandableScrollableWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(MediaQuery.paddingOf(context).top + 40),
              SvgPicture.asset("assets/logo_new.svg"),
              const Gap(10),
              const Gap(8),
              Text("Kindly provide mail registered with your \nMATRIC NUMBER ",
                  style: AppTheme.bodyTextStyle2.copyWith(height: 2),
                  textAlign: TextAlign.center),
              const Gap(34),
              Form(
                key: _form,
                child: CustomTextfield(
                  label: "Email",
                  controller: emailController,
                  hintText: "e.g. Josh@mail.com",
                ),
              ),
              const Gap(50),
              CustomButton(
                text: "Get Started",
                onTap: () {
                  if (!_form.currentState!.validate()) return;
                  AuthRepository.login(email: emailController.text)
                      .then((value) {
                    if (value.status) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ActionSelector()));
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
