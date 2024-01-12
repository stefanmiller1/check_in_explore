
importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-messaging.js');

   /*Update with yours config*/
    const firebaseConfig = {
      apiKey: "AIzaSyD-bDqaVGZmESyC-lCjIY_OkgSkZSXKRD0",
      authDomain: "cico-8298b.firebaseapp.com",
      projectId: "cico-8298b",
      storageBucket: "cico-8298b.appspot.com",
      messagingSenderId: "686667962875",
      appId: "1:686667962875:web:3d0fb0f07a951871fd535e",
      measurementId: "G-K2S4DN0XGL"
    };
  firebase.initializeApp(firebaseConfig);
  const messaging = firebase.messaging();

  /*messaging.onMessage((payload) => {
  console.log('Message received. ', payload);*/
  messaging.onBackgroundMessage(function(payload) {
    console.log('Received background message ', payload);

    const notificationTitle = payload.notification.title;
    const notificationOptions = {
      body: payload.notification.body,
    };

    self.registration.showNotification(notificationTitle,
      notificationOptions);
  });