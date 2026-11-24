<div align="center">

# 🐷 Tirelire

**Vos projets, un FCFA à la fois.**

Application mobile d'épargne par projets, en FCFA — gratuite, privée et utilisable hors ligne.

![Version](https://img.shields.io/badge/version-2.2-2E7D52?style=for-the-badge)
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

### 🗃️ Catégories de dépenses
- 🧩 Les retraits sont classés par **catégorie** (utilisation, urgence, santé, transport, éducation…)
- 📉 Répartition des dépenses par catégorie dans chaque projet

### 🔐 Confort et sécurité
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

### Option 2 — Héberger sur GitHub Pages *(recommandé)*
1. 📤 Déposez à la racine du dépôt : `index.html`, `sw.js`, `manifest.webmanifest`, `icon.svg`, `icon-180.png`, `icon-192.png`, `icon-512.png`
2. ⚙️ Dans **Settings → Pages**, choisissez la branche principale et le dossier `/ (root)`
3. 🌐 Ouvrez l'adresse fournie sur votre téléphone
4. 📲 Installez l'app : bouton **Installer** dans les Réglages, ou menu du navigateur → *Ajouter à l'écran d'accueil*

> 💡 **Mise à jour du service worker** : à chaque nouvelle version, changez le nom du cache dans `sw.js` (`const VERSION = 'tirelire-vX.Y'`) pour que les téléphones récupèrent les nouveaux fichiers.

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
└── 📘 README.md               → ce fichier
```

---

## 💾 Vos données

| | |
|---|---|
| 📍 **Où ?** | Dans le `localStorage` du navigateur, sur l'appareil — rien n'est envoyé sur Internet |
| 📤 **Exporter** | **JSON** (sauvegarde complète : projets, charges, paies, caisse, catégories, transferts) et **CSV** (mouvements, lisible dans Excel) |
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
- [x] 💰 Caisse : entrées par source, dépenses libres, paie liée à la caisse
- [ ] 📊 Statistiques globales (dépenses par catégorie, tendance mensuelle)
- [ ] ✅ Suivi par période pour les défis (case cochée à chaque semaine ou jour payé)
- [ ] 🔎 Recherche et filtres dans l'historique
- [ ] ☁️ Sauvegarde et synchronisation Google Drive
- [ ] 💡 Budget mensuel par catégorie, avec alerte de dépassement
- [x] 🐞 Corrections mineures : icône « école », participant modifiable à l'édition d'un mouvement, nettoyage du code PIN

---

## 📝 Historique des versions

| Version | Nouveautés |
|---|---|
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
