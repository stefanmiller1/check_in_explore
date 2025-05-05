
importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-messaging.js');

   /*Update with yours config*/
    var firebaseConfig = {
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
    console.log('Received background message', payload);

    // Ensure only background messages are handled here
  if (!payload.notification) return;

    // const notificationTitle = payload.notification.title;
    // const notificationOptions = {
    //   body: payload.notification.body,
    //   icon: "favicon.png",
    //   data: payload.notification.data
    // };

    // self.registration.showNotification(notificationTitle,
    //   notificationOptions);

  });

  // Handling push notification subscription inside the 'activate' event listener
  self.addEventListener('activate', function(event) {
      event.waitUntil(
          self.registration.pushManager.subscribe({
              userVisibleOnly: true,
              applicationServerKey: 'BCc_cyT2apphC8NxosVIQTC42C6IfaF4mh0xkJ2ZJgUC0YXJMS3FuxMQfVWomEmN4wqtSy6g4AhuI7m8fG52fVI'
          })
          .then(function(subscription) {
              console.log('Push subscription successful:', subscription);
          })
          .catch(function(error) {
              console.error('Push subscription failed:', error);
          })
      );
  });

  /// event listener for notification click
self.addEventListener("notificationclick", (event) => {
  console.log("On notification click: ", event.notification.tag);
  event.notification.close();
err
  // This looks to see if the current is already open and
  // focuses if it is
  event.waitUntil(
    clients
      .matchAll({
        type: "window",
      })
      .then((clientList) => {
        for (var client of clientList) {
          if (client.url === "/" && "focus" in client) return client.focus();
        }
        if (clients.openWindow) return clients.openWindow(event.notification.data.url);
      }),
  );
});

self.onnotificationclose = (event) => {
  console.log("On notification close: ", event.notification.tag);
};
