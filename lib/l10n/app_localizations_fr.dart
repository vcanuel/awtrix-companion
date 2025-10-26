// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'AWTRIX Companion';

  @override
  String get general => 'Général';

  @override
  String get matrix => 'Matrice';

  @override
  String get autoBrightness => 'Luminosité automatique';

  @override
  String get brightness => 'Luminosité';

  @override
  String get autoTransition => 'Transition automatique';

  @override
  String get matrixOff => 'Matrice éteinte';

  @override
  String get actions => 'Actions';

  @override
  String get reboot => 'Redémarrer';

  @override
  String get rebootDevice => 'Redémarre l\'appareil AWTRIX';

  @override
  String get rebootConfirmTitle => 'Redémarrer';

  @override
  String get rebootConfirmMessage =>
      'Êtes-vous sûr de vouloir redémarrer l\'appareil ?';

  @override
  String get cancel => 'Annuler';

  @override
  String get rebooting => 'Redémarrage en cours...';

  @override
  String get turnOn => 'Allumer';

  @override
  String get turnOff => 'Éteindre';

  @override
  String get turnOnMatrix => 'Allume la matrice LED';

  @override
  String get turnOffMatrix => 'Éteint la matrice LED';

  @override
  String get turnOffConfirmTitle => 'Éteindre';

  @override
  String get turnOffConfirmMessage =>
      'Êtes-vous sûr de vouloir éteindre la matrice LED ?';

  @override
  String get matrixTurnedOn => 'Matrice LED allumée';

  @override
  String get matrixTurnedOff => 'Matrice LED éteinte';

  @override
  String get sleepMode => 'Mode veille';

  @override
  String get sleepModeDescription => 'Met l\'appareil en veille profonde';

  @override
  String get sleepDuration => 'Durée de veille en secondes :';

  @override
  String get seconds => 'Secondes';

  @override
  String get oneHour => '1 heure = 3600s';

  @override
  String get activate => 'Activer';

  @override
  String sleepActivated(int duration) {
    return 'Mode veille activé pour ${duration}s';
  }

  @override
  String error(String message) {
    return 'Erreur: $message';
  }

  @override
  String get loadingError => 'Erreur de chargement';

  @override
  String get settingsUpdated => 'Paramètres mis à jour';

  @override
  String get awtrixServiceUnavailable => 'Service AWTRIX non disponible';

  @override
  String get message => 'Message';

  @override
  String get enterText => 'Entrez le texte de votre notification';

  @override
  String get enterTextHint => 'Entrez le texte';

  @override
  String get sendAsApp => 'Envoyer en tant qu\'app';

  @override
  String get sendAsAppDescription =>
      'Crée une app personnalisée au lieu d\'une notification temporaire';

  @override
  String get appName => 'Nom de l\'app';

  @override
  String get appNameDefault => 'companion';

  @override
  String get appNameHelper => 'Identifiant unique de l\'app personnalisée';

  @override
  String get icon => 'Icône';

  @override
  String get iconId => 'Icône (ID)';

  @override
  String get chooseIcon => 'Choisir une icône';

  @override
  String get textColor => 'Couleur du texte';

  @override
  String get textEffects => 'Effets de texte';

  @override
  String get blink => 'Clignotement (ms)';

  @override
  String get blinkHelper => 'Intervalle de clignotement en millisecondes';

  @override
  String get fade => 'Fondu (ms)';

  @override
  String get fadeHelper => 'Intervalle de fondu en millisecondes';

  @override
  String get rainbowEffect => 'Effet arc-en-ciel';

  @override
  String get rainbowEffectDescription =>
      'Fait défiler chaque lettre à travers le spectre RGB';

  @override
  String get backgroundColor => 'Couleur de fond';

  @override
  String get backgroundColorDescription =>
      'Définir une couleur de fond personnalisée';

  @override
  String get chooseBackgroundColor => 'Choisir la couleur de fond';

  @override
  String get overlayEffect => 'Effet de superposition';

  @override
  String get overlayEffectHelper =>
      'Ajoute un effet visuel par-dessus le texte';

  @override
  String get none => 'Aucun';

  @override
  String get duration => 'Durée (secondes)';

  @override
  String get durationDefault => '5';

  @override
  String get durationHelper =>
      'Durée d\'affichage de la notification (défaut: 5s)';

  @override
  String get durationMinimum => 'La durée doit être au moins 1 seconde';

  @override
  String get send => 'Envoyer';

  @override
  String get notificationSent => 'Notification envoyée avec succès!';

  @override
  String appCreated(String name) {
    return 'App \"$name\" créée avec succès!';
  }

  @override
  String get settings => 'Paramètres';

  @override
  String get awtrixIp => 'Adresse IP AWTRIX';

  @override
  String get save => 'Enregistrer';

  @override
  String get demoMode => 'Mode démo';

  @override
  String get demoModeDescription => 'Tester sans appareil AWTRIX réel';

  @override
  String get language => 'Langue';

  @override
  String get french => 'Français';

  @override
  String get english => 'Anglais';

  @override
  String get settingsSaved => 'Paramètres enregistrés';

  @override
  String get pleaseEnterAddress => 'Veuillez entrer une adresse';

  @override
  String get invalidIpAddress =>
      'Veuillez entrer une adresse IP ou un nom d\'hôte valide';

  @override
  String get deviceDiscovery => 'Découverte d\'appareils';

  @override
  String get discoverDevices => 'Découvrir les appareils';

  @override
  String get discoveringDevices => 'Recherche d\'appareils sur votre réseau...';

  @override
  String devicesFound(int count) {
    return '$count appareil(s) trouvé(s)';
  }

  @override
  String get noDevicesFound =>
      'Aucun appareil trouvé. Assurez-vous que votre AWTRIX est connecté au même réseau.';

  @override
  String get selectDevice => 'Sélectionner un appareil';

  @override
  String get manualEntry => 'Saisie manuelle';

  @override
  String get enterManually => 'Entrer l\'adresse IP manuellement';

  @override
  String get confirmedAwtrix => 'Appareil AWTRIX confirmé';

  @override
  String get possibleDevice => 'Appareil possible';

  @override
  String get stopDiscovery => 'Arrêter la découverte';

  @override
  String get refreshDevices => 'Actualiser';

  @override
  String get validatingDevice => 'Validation de l\'appareil...';

  @override
  String get deviceValidated => 'Appareil validé avec succès';

  @override
  String get deviceValidationFailed =>
      'Impossible de se connecter à l\'appareil';

  @override
  String get notAnAwtrixDevice => 'Pas un appareil AWTRIX';

  @override
  String get connected => 'Connecté';

  @override
  String get demoModeActive => 'Mode démo actif';

  @override
  String get apiCallsSimulated => 'Les appels API sont simulés';

  @override
  String get previousApp => 'App précédente';

  @override
  String get nextApp => 'App suivante';

  @override
  String get loading => 'Chargement...';

  @override
  String get generalTab => 'Général';

  @override
  String get messagesTab => 'Messages';

  @override
  String get notifications => 'Notifications';

  @override
  String get pleaseEnterText => 'Veuillez entrer un texte';

  @override
  String get pleaseEnterAppName => 'Veuillez entrer un nom d\'app';

  @override
  String get pleaseEnterDuration => 'Veuillez entrer une durée';

  @override
  String iconDownloaded(int iconId) {
    return 'Icône $iconId téléchargée et uploadée!';
  }

  @override
  String get close => 'Fermer';

  @override
  String get iconsFromLaMetric => 'Les icônes proviennent de LaMetric';

  @override
  String get visitLaMetricIcons =>
      'Visitez https://developer.lametric.com/icons pour parcourir toutes les icônes disponibles et trouver leur ID.';

  @override
  String get popularIcons => 'Icônes populaires :';

  @override
  String get heart => 'Coeur';

  @override
  String get email => 'Email';

  @override
  String get sun => 'Soleil';

  @override
  String get moon => 'Lune';

  @override
  String get check => 'Check';

  @override
  String get cross => 'Croix';

  @override
  String get alert => 'Alerte';

  @override
  String get bell => 'Cloche';

  @override
  String get star => 'Étoile';

  @override
  String get home => 'Maison';

  @override
  String get bulb => 'Ampoule';

  @override
  String get music => 'Musique';

  @override
  String get download => 'Télécharger';

  @override
  String get select => 'Sélectionner';

  @override
  String get pleaseEnterValidIconId => 'Veuillez entrer un ID d\'icône valide';

  @override
  String get downloadingIcon => 'Téléchargement de l\'icône...';
}
