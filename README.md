<div align="center">

# 🐷 Tirelire

**Vos projets, un FCFA à la fois.**

Application mobile d'épargne par projets, en FCFA — gratuite, privée et utilisable hors ligne.

![Version](https://img.shields.io/badge/version-3.4-2E7D52?style=for-the-badge)
![PWA](https://img.shields.io/badge/PWA-installable-123B27?style=for-the-badge)
![Hors ligne](https://img.shields.io/badge/hors%20ligne-oui-4A9B6E?style=for-the-badge)
![Stack](https://img.shields.io/badge/HTML%20%2B%20CSS%20%2B%20JS-sans%20d%C3%A9pendance-BDE9CD?style=for-the-badge&labelColor=123B27)
![Statut](https://img.shields.io/badge/projet-personnel-lightgrey?style=for-the-badge)

</div>

---

## ✨ Présentation

**Tirelire** aide à épargner pour des projets concrets (télé, voiture, voyage, maison…). Tout part de la **caisse** : on y enregistre l'argent réel reçu (paie, don, prime…), puis on le répartit entre charges et projets. Une fois l'argent réuni, on **réalise** le projet : il est archivé avec tout son historique.

Tout tient dans **un seul fichier HTML** : pas de serveur, pas de compte, pas de publicité. Les données restent **sur votre téléphone**.

---

## 📱 Fonctionnalités

### 🏠 Écran d'accueil
- 👀 **Une seule vue, sans défilement** : carrousel de widgets en haut, boutons en dessous, petit footer *Tirelire · Version x.y*
- 🔘 **9 boutons** : Mes projets · Réalisés · Nouveau projet · Caisse · Gérer la paie · Charges · Historique · Sauvegarde · Réglages, chacun avec une information utile (nombre de projets, solde de la caisse, paie à répartir…)
- 🟠 **Pastille d'alerte** sur *Gérer la paie* (paie à répartir) et *Sauvegarde* (sauvegarde à faire)
- 📂 **Mes projets** ouvre la liste (onglets En cours / Réalisés, tags, appui long) avec un bouton retour vers l'accueil
- 🔄 Les widgets défilent tout seuls (en pause quand vous touchez, tapez ou ouvrez un écran)

### 🧩 Widgets d'accueil
- 📊 **Mes statistiques** : anneau de progression globale, total épargné, caisse, épargne du mois, objectifs atteints, reste
- 📈 **Évolution** : épargne mois par mois sur les 6 derniers mois
- 🏦 **Caisse** : solde, entrées et dépenses du mois, boutons *Encaisser* et *Dépenser*
- ⚡ **Ajout rapide** : choisissez un projet, tapez ou touchez un montant (+500, +1 000, +5 000, +10 000) : l'argent sort de la caisse
- 🏁 **Défis du moment** : cochez directement la période à payer
- 💬 **Citations** sur l'épargne, l'argent, la discipline et la patience, qui défilent toutes les 8 secondes (un toucher passe à la suivante)
- 👈 Carrousel à faire glisser ; masquable dans **Réglages → Widgets d'accueil**
- 🚀 **Raccourcis d'icône** (Android, app installée) : *Ajouter de l'argent*, *Ma caisse*, *Défi du moment* ; liens directs `?action=add`, `?action=cash`, `?action=challenge`

> ℹ️ Ce sont des widgets **dans l'application**. Les widgets natifs de l'écran d'accueil du téléphone ne sont pas possibles avec une web app (iOS) et demandent du code Android natif dans l'APK.

### 💰 Caisse
- 🏦 La **caisse** contient l'argent réel disponible : tout versement vers un projet ou une charge en sort
- ➕ **Encaisser** par source : Paie, Don, Prime, Vente, Remboursement, Solde de départ, Autre
- ➖ **Dépenser** hors projet (ex. 500 F pour un jus) avec catégorie et motif, conservé dans l'historique
- 🔒 Impossible de verser à un projet plus que ce que contient la caisse
- ↩️ Un retrait de projet **retourne dans la caisse** ; un transfert entre projets ne touche pas la caisse
- 🧾 Historique clair avec filtres **Tout / Entrées / Sorties**
- 👥 Les versements d'un autre participant d'une cagnotte partagée ne touchent pas votre caisse

### 🎯 Projets d'épargne
- 🏷️ Un projet = un nom, un objectif, une échéance, une **couleur** et une **icône** (10 palettes, plus de 70 icônes)
- 📊 Barre de progression, solde, reste à épargner et **montant mensuel conseillé** jusqu'à l'échéance
- 📈 Courbe d'évolution du solde et récapitulatif mensuel
- 🎉 Célébrations aux paliers **25 %, 50 %, 75 % et 100 %**
- 👥 **Cagnotte partagée** : plusieurs participants cotisent, avec le total par personne
- 👆 **Appui long sur un projet** : aperçu rapide (solde, progression, échéance, défi), **ajout d'argent depuis la caisse** sans ouvrir le projet, accès direct à *Ouvrir* et *Modifier*

### 🏷️ Tags (types de projets)
- 🗂️ Un **tag** classe un projet par type (ex. « Projets personnels », « Famille »), avec son **icône** et sa **couleur**
- ✨ L'accueil affiche **une carte animée par tag** : nombre de projets, solde cumulé, objectifs atteints, reste à épargner et progression globale
- 👆 Un clic **déplie** la carte pour gérer chaque projet individuellement ; une carte **« Sans tag »** regroupe les autres
- 🔀 Bascule **Tags / Liste** pour revenir à la liste à plat (choix mémorisé)
- ➕ Création **libre** : à la volée depuis la fiche d'un projet, ou dans **Réglages → Mes tags** (renommer, changer l'icône et la couleur, supprimer)
- ♻️ Un tag existant est proposé pour tous les autres projets, y compris pour ceux déjà créés
- 🛡️ Supprimer un tag conserve les projets, qui deviennent « sans tag »
- 👆 **Appui long sur un tag** : détails (solde cumulé, objectifs, reste), liste de ses projets et bouton *Modifier le tag*

### 🏆 Réaliser un projet
- 🛒 Bouton **« Réaliser le projet »** : on enregistre le montant payé, la date et une note
- 💸 Un éventuel **reliquat** est libéré automatiquement
- 🗂️ Le projet passe dans l'onglet **Réalisés**, en lecture seule : temps mis pour le réaliser, délai pour atteindre l'objectif, total épargné, historique complet
- ↩️ **Rouvrir** un projet réalisé par erreur est possible
- ⏳ Un projet peut atteindre 100 % sans être réalisé (achat pas encore effectué)

### 🔁 Transferts entre projets
- ↔️ Déplacer de l'argent d'un projet vers un autre, avec aperçu des deux soldes
- 🔗 Les deux mouvements sont liés : **annuler le transfert** retire les deux d'un coup
- 🧮 Un transfert n'est compté ni comme épargne, ni comme dépense

### 💼 Paie et charges
- 🧾 **Charges fixes** (loyer, eau, transport…) avec icône et catégorie
- 💵 **Gérer la paie** : disponible seulement pour une entrée de caisse de source « Paie », et **une seule fois par paie**
- 🧮 Impossible de répartir plus que la paie ; le reste demeure dans la caisse
- 🕘 Historique des paies ; supprimer une répartition rend l'argent à la caisse et la paie redevient disponible

### 🏁 Défis d'épargne
- 📅 52 semaines, 30 jours, 12 mois, 26 semaines, 100 jours, 90 jours — ou un défi **personnalisé**
- ➕ Montant fixe ou progressif, avec objectif du moment et progression
- ✅ **Suivi par période** : une case à cocher par semaine, jour ou mois (ex. 1 000 F par semaine)
- 🏦 Cocher **prélève le montant dans la caisse** et l'ajoute au projet ; refusé si la caisse est insuffisante
- ↩️ Décocher annule le versement et rend l'argent à la caisse ; supprimer le mouvement décoche la case
- ⏰ Chaque période est marquée *Payé*, *À payer*, *En retard* ou *À venir*

### 🗃️ Catégories de dépenses
- 🧩 Les retraits sont classés par **catégorie** (utilisation, urgence, santé, transport, éducation…)
- 📉 Répartition des dépenses par catégorie dans chaque projet

### 🔐 Confort et sécurité
- ✨ **Animation de démarrage** à chaque ouverture, et au retour dans l'app après plus de 15 secondes d'absence (le code PIN est alors redemandé)
- 🆕 **Écran des nouveautés** : après chaque mise à jour, la liste des nouveautés et corrections depuis votre dernière version
- ℹ️ **À propos** (Réglages) : version, auteur, historique complet des versions
- 🔢 **Code PIN** à 4 chiffres et 🖐️ **déverrouillage biométrique**
- 🌗 Thème **clair / sombre / auto**
- 🔔 **Rappels d'épargne** (quotidiens, hebdomadaires, mensuels)
- 💾 Rappel de **sauvegarde** quand l'export date de plus de 30 jours

### 📦 Installation et hors ligne
- 📲 **Installable** sur l'écran d'accueil (Android, iOS, ordinateur)
- 📴 Fonctionne **sans connexion** grâce au service worker
- 🔄 Mise à jour automatique en arrière-plan, appliquée au lancement suivant

---

## 🚀 Installation

### Option 1 — Utiliser le fichier seul
Ouvrez simplement `index.html` dans un navigateur mobile. Tout fonctionne, sauf l'installation et le mode hors ligne (qui exigent HTTPS).

### Option 3 — Générer l'APK Android 🤖
Un workflow **GitHub Actions** construit un APK installable (enveloppe [Capacitor](https://capacitorjs.com) autour de l'app).
1. 📤 Poussez le dépôt avec les dossiers `.github/workflows/` et `android-app/`
2. ▶️ Onglet **Actions → Construire l'APK Android → Run workflow** (ou poussez une étiquette `v2.8`, l'APK est alors joint à la *release*)
3. 📥 Téléchargez **Tirelire-apk** en bas de l'exécution, dézippez, puis installez `Tirelire.apk` (autorisez les sources inconnues)

> ⚠️ L'APK est signé avec la clé de débogage : il convient à un usage personnel. Ses données sont **séparées** de celles de la version web : exportez un JSON depuis l'une, importez-le dans l'autre. Le déverrouillage biométrique peut ne pas être disponible dans l'APK ; le code PIN fonctionne.

### Option 2 — Héberger sur GitHub Pages *(recommandé)*
1. 📤 Déposez à la racine du dépôt : `index.html`, `sw.js`, `manifest.webmanifest`, `icon.svg`, `icon-180.png`, `icon-192.png`, `icon-512.png`
2. ⚙️ Dans **Settings → Pages**, choisissez la branche principale et le dossier `/ (root)`
3. 🌐 Ouvrez l'adresse fournie sur votre téléphone
4. 📲 Installez l'app : bouton **Installer** dans les Réglages, ou menu du navigateur → *Ajouter à l'écran d'accueil*

> 💡 **Nouvelle version** : changez le nom du cache dans `sw.js` (`const VERSION = 'tirelire-vX.Y'`), `APP_VERSION` dans `index.html`, et ajoutez une entrée en tête de `CHANGELOG` pour alimenter l'écran des nouveautés.

---

## 🗂️ Structure du projet

```
📁 tirelire/
├── 📄 index.html              → l'application complète (HTML + CSS + JS)
├── ⚙️ sw.js                   → service worker (cache et mode hors ligne)
├── 📋 manifest.webmanifest    → métadonnées d'installation (PWA)
├── 🖼️ icon.svg                → icône source
├── 🖼️ icon-180.png            → icône iOS
├── 🖼️ icon-192.png            → icône Android
├── 🖼️ icon-512.png            → icône haute résolution
├── 🤖 .github/workflows/build-apk.yml → construit l'APK Android (GitHub Actions)
├── 📱 android-app/            → configuration Capacitor de l'APK
└── 📘 README.md               → ce fichier
```

---

## 💾 Vos données

| | |
|---|---|
| 📍 **Où ?** | Dans le `localStorage` du navigateur, sur l'appareil — rien n'est envoyé sur Internet |
| 💾 **Sauvegarder** | Le bouton *Exporter JSON* ouvre une fenêtre avec le récapitulatif (date, projets, mouvements, total épargné, caisse, taille), puis **Enregistrer** ou **Partager** (Drive, Mega, WhatsApp…). Nom du fichier : `Tirelire_2026-11-26_v1.json`, le numéro `vN` augmentant à chaque sauvegarde du jour |
| 📤 **Exporter** | **JSON** (sauvegarde complète : projets, tags, charges, paies, caisse, catégories, transferts) et **CSV** (mouvements, lisible dans Excel) |
| 📥 **Importer** | JSON, y compris les **anciens fichiers** des versions précédentes |
| 🗑️ **Effacer** | Réglages → *Tout effacer* (double confirmation) |

> ⚠️ Vider les données du navigateur efface l'application. **Exportez régulièrement un JSON** pour ne rien perdre.

> 🔒 Le code PIN et la biométrie protègent l'accès à l'écran de l'application, mais ne chiffrent pas les données stockées.

---

## 🛠️ Technique

- 🧱 **Aucune dépendance** : HTML, CSS et JavaScript natifs, un seul fichier
- 📱 Pensé **mobile d'abord**, avec gestion des zones sûres et du mode sombre
- ♿ Respect de `prefers-reduced-motion`, focus visibles, rôles ARIA
- 💰 Montants en **FCFA**, dates et libellés en **français**
- ⚙️ Stratégie de cache : cache d'abord + rafraîchissement en arrière-plan

---

## 🗺️ Feuille de route

- [x] 🏆 Réalisation de projets et onglet *Réalisés*
- [x] 📴 Service worker et installation hors ligne
- [x] 🔁 Vrais transferts entre projets
- [x] 🗃️ Catégories dans les exports JSON et CSV
- [x] 🏷️ Tags : regroupement par type sur l'accueil, gestion dans les réglages
- [x] 💰 Caisse : entrées par source, dépenses libres, paie liée à la caisse
- [ ] 📊 Statistiques globales (dépenses par catégorie, tendance mensuelle)
- [x] ✅ Suivi par période pour les défis (case cochée à chaque semaine ou jour payé)
- [ ] 🔎 Recherche et filtres dans l'historique
- [x] 🤖 APK Android via GitHub Actions
- [ ] ☁️ Sauvegarde et synchronisation Google Drive
- [ ] 💡 Budget mensuel par catégorie, avec alerte de dépassement
- [x] 🐞 Corrections mineures : icône « école », participant modifiable à l'édition d'un mouvement, nettoyage du code PIN

---

## 📝 Historique des versions

| Version | Nouveautés |
|---|---|
| **3.4** | 🔎 Recherche globale : projets, mouvements, caisse, tags, charges, paies · montants, notes, dates, sans accents · filtres et récentes |
| **3.3** | 🛠️ Correctif : « Exporter JSON » des réglages s'affichait derrière le panneau · accueil adapté à la hauteur de l'écran |
| **3.2** | 🏠 Nouvel écran d'accueil en une seule vue : carrousel de widgets, 9 boutons vers les écrans, footer avec la version · liste des projets dans « Mes projets » |
| **3.1** | 🧩 Widgets d'accueil (statistiques, ajout rapide, défis du moment, citations) · ⚡ Raccourcis sur l'icône Android · réglage pour les masquer |
| **3.0** | ✨ Animation de démarrage à chaque réouverture · 🆕 Écran des nouveautés après chaque mise à jour · ℹ️ Menu « À propos » dans les réglages · 🔒 PIN redemandé après une absence |
| **2.9** | 💾 Modale de sauvegarde (aperçu des données, *Enregistrer* ou *Partager*) · 🏷️ Fichiers nommés `Tirelire_AAAA-MM-JJ_vN.json` |
| **2.8** | 🐞 L'appui long ne sélectionne plus le texte · 🛡️ Demande au navigateur de protéger les données contre l'effacement automatique · 🤖 Workflow GitHub Actions pour générer l'APK Android |
| **2.7** | 👆 Appui long sur un projet : aperçu + ajout rapide depuis la caisse · appui long sur un tag : détails, liste des projets, modification |
| **2.6** | 🐞 Correctif : un mouvement daté avant la création du projet ne fait plus planter la courbe d'évolution |
| **2.5** | ✅ Suivi des défis : cases à cocher par période, versement prélevé sur la caisse, retards signalés |
| **2.4** | 🐞 Correctif : un projet aux données invalides (défi corrompu, date illisible) ne fait plus planter l'app · données assainies au chargement et à l'import |
| **2.3** | 🏷️ Tags avec icône et couleur · cartes animées dépliables sur l'accueil · bascule Tags/Liste · tags dans les exports JSON/CSV |
| **2.2** | 💰 Caisse (entrées par source, dépenses libres, historique) · 🔒 Paie utilisable une seule fois, versements limités à la caisse · 📤 Caisse dans les exports JSON/CSV |
| **2.1** | 🐞 Icône « école » ajoutée · le participant d'un mouvement s'affiche et se modifie à l'édition · doublon de code supprimé |
| **2.0** | 🔁 Transferts entre projets · 🗃️ Catégories et transferts dans le JSON/CSV · 📥 Import rétrocompatible des anciens fichiers |
| **1.9** | 🏆 « Réaliser le projet » et onglet *Réalisés* · 📴 Service worker, manifest et installation |
| **1.8** | 🧩 Catégories de dépenses |

---

## 📄 Licence

Projet **personnel**, tous droits réservés. Le code n'est pas destiné à être réutilisé ou redistribué sans accord de l'auteur.

---

<div align="center">

Fait avec 💚 par **Pierre Valdeze** — *un FCFA à la fois.*

</div>
