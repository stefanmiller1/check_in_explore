import 'package:check_in_domain/check_in_domain.dart';
import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class NewPaymentMethodWidget extends StatefulWidget {

  final UserProfileModel profile;
  final DashboardModel model;
  final Function(String token) didSaveNewPaymentMethod;

  const NewPaymentMethodWidget({super.key, required this.model, required this.didSaveNewPaymentMethod, required this.profile});

  @override
  State<NewPaymentMethodWidget> createState() => _NewPaymentMethodWidgetState();
}

class _NewPaymentMethodWidgetState extends State<NewPaymentMethodWidget> {

  CardFieldInputDetails? _card;
  late bool _isComplete = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        titleTextStyle: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
        elevation: 0,
        title: Text('New Payment Method'),
        iconTheme: IconThemeData(
            color: widget.model.paletteColor
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Icon(Icons.lock, color: widget.model.paletteColor),
              SizedBox(height: 15),
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CardField(
                  decoration: InputDecoration(
                    // focusedBorder: ,
                    fillColor: widget.model.accentColor,
                    filled: true,
                    border: InputBorder.none,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  enablePostalCode: false,
                  onCardChanged: (card) {
                    setState(() {
                      _card = card;
                      _isComplete = card?.complete ?? false;
                    });
                  },
                ),
              ),
              const SizedBox(height: 15),
              InkWell(
                onTap: () async {

                  if (_card != null && _card?.validExpiryDate == CardValidationState.Valid && _card?.validCVC == CardValidationState.Valid && _card?.validNumber == CardValidationState.Valid) {
                    var cardToken = await Stripe.instance.createToken(CreateTokenParams.card(params: CardTokenParams(
                      type: TokenType.Card,
                    )));

                    widget.didSaveNewPaymentMethod(cardToken.id);
                  } else {
                    final snackBar = SnackBar(
                        elevation: 4,
                        backgroundColor: widget.model.paletteColor,
                        content: Text('One or more of your details might be incorrect, please double check and try again.', style: TextStyle(color: widget.model.webBackgroundColor))
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }

                },
                child: Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: (_isComplete) ? widget.model.paletteColor : widget.model.accentColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(child: Text('Save New Card', style: TextStyle(color: (_isComplete) ? widget.model.accentColor : widget.model.paletteColor, fontWeight: FontWeight.bold))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}