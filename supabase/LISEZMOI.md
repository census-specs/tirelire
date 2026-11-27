# Activer les comptes et la synchronisation (≈ 10 minutes)

Tirelire fonctionne sans compte. Cette configuration est **à faire une seule fois** ; tant qu'elle n'est pas faite, la section « Compte & synchronisation » reste invisible dans les réglages et rien ne change pour les utilisateurs.

## 1. Créer le projet Supabase
1. Allez sur **supabase.com** → *Start your project* → connectez-vous (GitHub ou e-mail).
2. **New project** : nom `tirelire`, choisissez un mot de passe de base de données (notez-le), région la plus proche (Europe : *Frankfurt* ou *Paris*), plan **Free**.
3. Attendez ~2 minutes que le projet soit prêt.

## 2. Créer les tables (script SQL)
1. Menu de gauche → **SQL Editor** → **New query**.
2. Ouvrez `supabase/01_comptes_et_sync.sql`, copiez tout, collez, cliquez **Run**.
3. Résultat attendu : *Success. No rows returned*. Vous pouvez le relancer sans risque.

## 3. Régler l'e-mail
Menu **Authentication** → **Sign In / Providers** (ou *Providers*) → **Email** : activé.
- **Confirm email = désactivé** : le compte marche tout de suite (le plus simple pour démarrer).
- **Confirm email = activé** : l'utilisateur reçoit un lien. Dans ce cas allez dans **Authentication → URL Configuration** et mettez **Site URL** = `https://tirelire-pi.vercel.app`.
Dans les deux cas, « Mot de passe oublié » fonctionne avec cette même URL.

## 4. Brancher l'application
1. Menu **Project Settings → API** (ou bouton *Connect*). Copiez :
   - **Project URL** (ex. `https://abcdxyz.supabase.co`)
   - la clé **anon public** (longue, commence par `eyJ…`) — ou **publishable** (`sb_publishable_…`).
2. Dans `index.html`, cherchez cette ligne et remplissez-la :
   ```js
   var CLOUD={url:'https://abcdxyz.supabase.co',key:'VOTRE_CLE_ANON'};
   ```
3. Publiez sur GitHub/Vercel comme d'habitude.

> ⚠️ N'utilisez **jamais** la clé `service_role` (secrète). La clé anon/publishable est faite pour être publique : la sécurité vient des règles (RLS) du script SQL — chacun ne peut lire que ses propres données.

## 5. Tester
1. Ouvrez l'app → Réglages → **Compte & synchronisation** → *Créer un compte*.
2. Dans Supabase → **Table Editor → user_data** : une ligne apparaît avec vos données.
3. Installez l'app sur un 2ᵉ appareil, connectez-vous : vos projets arrivent.

## Et les données déjà présentes dans l'app ?
Rien n'est perdu : à la création du compte, les données de l'appareil sont **envoyées** sur le compte. Si le compte contient déjà des données et que l'appareil aussi, l'app propose **Fusionner** (recommandé), *Garder cet appareil*, *Garder le compte* ou *Décider plus tard*. Avant tout remplacement, une copie de sécurité est gardée et restaurable dans Réglages.

*Limite de la fusion : un élément supprimé sur un appareil peut réapparaître s'il existe encore sur l'autre.*
