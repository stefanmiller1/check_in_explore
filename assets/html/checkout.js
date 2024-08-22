// This is your test publishable API key.
const stripe = Stripe('pk_live_51JEcLgBZ5oSwwStvYYnw2YdEmVmzwIWc2DVGqt3GE8hihczLbaDwLhSXO0W5C3nFDiLti4SF301OvVRPXbA56Mjx003sJdM5fT', {
    apiVersion: '2020-08-27',
});

//const stripe = Stripe('sk_test_51JEcLgBZ5oSwwStvxrODBvRmrf2AEzpugCaOzoHGk2QBDVH5ouxFlUPo0nwLJVb4yatx3ZaLCj5NWU8QKtqyZew400sC20c0Z2', {
//    apiVersion: '2020-08-27',
//});


let elements;
let clientSecret;

initialize();
checkStatus();

window.parent.addEventListener('message', initialize, false);


document
  .querySelector("#payment-form")
  .addEventListener("submit", handleSubmit);

// Fetches a payment intent and captures the client secret
async function initialize(e) {
    try {
        if (!e || !e.data) {
            console.error("Event object or event data is missing.");
            return;
        }

        var data = JSON.parse(e.data);
        if (!data || !data.data) {
            console.error("Invalid data format or missing 'data' property.");
            return;
        }
        clientSecret = data['data'];
        console.log(clientSecret);

      const appearance = {
        theme: 'flat',
        variables: {
            colorPrimary: '#000000',
        }
      };
      elements = stripe.elements({ appearance, clientSecret });

      setTimeout(() => {
              console.log('Value of elements:', elements.create);
          }, 1000); //

      paymentElement = elements.create('payment', {
        paymentMethodOrder: ['apple_pay', 'google_pay', 'card', 'klarna', 'afterpay_clearpay']
      });
      paymentElement.mount("#payment-element");
  } catch (error) {
          console.error("An error occurred during initialization:", error);
      }
}

async function handleSubmit(event) {
try {
  event.preventDefault();

    console.log('trtyying');
    console.log(elements);

    if (!stripe || !elements) {
        return;
    }

    setLoading(true);

    const { error } = await stripe.confirmPayment({
        elements,
        redirect: 'if_required',
        confirmParams: {
          // Make sure to change this to your payment completion page
          return_url: "http://www.cincout.ca/reservations",
        },
    });

    if (error == null) {
        window.parent.postMessage('success', '*');
        return;
    }


      // This point will only be reached if there is an immediate error when
      // confirming the payment. Otherwise, your customer will be redirected to
      // your `return_url`. For some payment methods like iDEAL, your customer will
      // be redirected to an intermediate site first to authorize the payment, then
      // redirected to the `return_url`.

    //  console.log(error);
    //  console.log(elements);
    //  if (error.type === "card_error" || error.type === "validation_error") {
    //    showMessage(error.message);
    //  } else {
    //    console.log('ooops');
        console.log(error.message);
        showMessage("An unexpected error occurred.", error.message);
    //  }

      setLoading(false);
  } catch (error) {
      showMessage("An unexpected error occurred.");
      console.error("An error occurred during Submit:", error);
    }
}

// Fetches the payment intent status after payment submission
async function checkStatus() {
  const clientSecret = new URLSearchParams(window.location.search).get(
    "payment_intent_client_secret"
  );

  if (!clientSecret) {
    return;
  }

  const { paymentIntent } = await stripe.retrievePaymentIntent(clientSecret);

  switch (paymentIntent.status) {
    case "succeeded":
      showMessage("Payment succeeded!");
      break;
    case "processing":
      showMessage("Your payment is processing.");
      break;
    case "requires_payment_method":
      showMessage("Your payment was not successful, please try again.");
      break;
    default:
      showMessage("Something went wrong.");
      break;
  }
}

// ------- UI helpers -------

function showMessage(messageText) {
  const messageContainer = document.querySelector("#payment-message");

  messageContainer.classList.remove("hidden");
  messageContainer.textContent = messageText;

  setTimeout(function () {
    messageContainer.classList.add("hidden");
    messageText.textContent = "";
  }, 4000);
}

// Show a spinner on payment submission
function setLoading(isLoading) {
  if (isLoading) {
    // Disable the button and show a spinner
    document.querySelector("#submit").disabled = true;
    document.querySelector("#spinner").classList.remove("hidden");
    document.querySelector("#button-text").classList.add("hidden");
  } else {
    document.querySelector("#submit").disabled = false;
    document.querySelector("#spinner").classList.add("hidden");
    document.querySelector("#button-text").classList.remove("hidden");
  }
}