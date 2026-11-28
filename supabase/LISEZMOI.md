# Activer les comptes et la synchronisation (≈ 10 minutes)

Tirelire fonctionne sans compte. Cette configuration est **à faire une seule fois** ; tant qu'elle n'est pas faite, la section « Compte & synchronisation » reste invisible dans les réglages et rien ne change pour les utilisateurs.

## 1. Créer le projet Supabase
1. Allez sur **supabase.com** → *Start your project* → connectez-vous (GitHub ou e-mail).
2. **New project** : nom `tirelire`, choisissez un mot de passe de base de données (notez-le), région la plus proche (Europe : *Frankfurt* ou *Paris*), plan **Free**.
3. Attendez ~2 minutes que le projet soit prêt.

## 2. Créer les tables (script SQL)
1. Menu de gauche → **SQL Editor** → **New query**.
2. Ouvrez `supabase/01_comptes_et_sync.sql`, copiez tout, collez, cliquez **Run**.
3. Nouvelle *query*, puis même chose avec `supabase/02_projets_partages.sql` (projets partagés, v4.1).
4. Nouvelle *query*, puis `supabase/03_versements.sql` (versements Mobile Money, v4.2). **Ordre : 01, 02, puis 03.**
5. Résultat attendu à chaque fois : *Success. No rows returned*. Vous pouvez les relancer sans risque.

## 3. Régler l'e-mail
Menu **Authentication** → **Sign In / Providers** (ou *Providers*) → **Email** : activé.
- **Confirm email = désactivé** : le compte marche tout de suite (le plus simple pour démarrer).
- **Confirm email = activé** : l'utilisateur reçoit un lien. Dans ce cas allez dans **Authentication → URL Configuration** et mettez **Site URL** = `https://tirelire-pi.vercel.app`.
Dans les deux cas, « Mot de passe oublié » fonctionne avec cette même URL.

## 4. Brancher l'application
1. Menu **Project Settings → API** (ou bouton *Connect*). Copiez :
   - **Project URL** (ex. `https://abcdxyz.supabase.co`)
   - la clé **anon public** (longue, commence par `eyJ…`) — ou **publishable** (`sb_publishable_…`).
2. Ouvrez le fichier **`config.js`** (un seul endroit pour l'app et la page publique) et remplissez-le :
   ```js
   window.TIRELIRE_CONFIG = {
     url: 'https://abcdxyz.supabase.co',
     key: 'VOTRE_CLE_ANON',
     appUrl: 'https://tirelire-pi.vercel.app'
   };
   ```
3. Publiez sur GitHub/Vercel comme d'habitude. Fichiers à publier : `index.html`, `sw.js`, `config.js`, `projet.html` et `vercel.json` (ce dernier fait fonctionner les liens `/p/mon-projet`).

> ⚠️ N'utilisez **jamais** la clé `service_role` (secrète). La clé anon/publishable est faite pour être publique : la sécurité vient des règles (RLS) du script SQL — chacun ne peut lire que ses propres données.

## 5. Tester
1. Ouvrez l'app → Réglages → **Compte & synchronisation** → *Créer un compte*.
2. Dans Supabase → **Table Editor → user_data** : une ligne apparaît avec vos données.
3. Installez l'app sur un 2ᵉ appareil, connectez-vous : vos projets arrivent.

## Et les données déjà présentes dans l'app ?
Rien n'est perdu : à la création du compte, les données de l'appareil sont **envoyées** sur le compte. Si le compte contient déjà des données et que l'appareil aussi, l'app propose **Fusionner** (recommandé), *Garder cet appareil*, *Garder le compte* ou *Décider plus tard*. Avant tout remplacement, une copie de sécurité est gardée et restaurable dans Réglages.

*Limite de la fusion : un élément supprimé sur un appareil peut réapparaître s'il existe encore sur l'autre.*

## Projets partagés (v4.1)
- Dans l'app : tuile **Projets partagés** sur l'accueil (elle apparaît dès que `config.js` est rempli) → **+** → choisir un projet, un titre, un lien (slug), un compte MTN et/ou Orange.
- Le lien `https://…/p/votre-slug` ouvre la page publique (avancement, reste à épargner) ; le bouton **Participer** ouvre l'app et ajoute le projet aux « Projets rejoints » (compte requis).
- Les numéros Mobile Money ne sont **jamais** visibles sur la page publique : seuls le créateur et les participants (dans l'app) les voient.
- Test rapide : créez un projet partagé, ouvrez son lien dans un navigateur privé, vérifiez la page, touchez *Participer*.
- Les aperçus WhatsApp du lien montrent un texte générique (un aperçu personnalisé demanderait une fonction serveur).

## Versements Mobile Money (v4.2)
1. Le participant ouvre le projet dans l'app → voit les numéros MTN/Orange → envoie l'argent avec son téléphone → touche **J'ai versé** et saisit le montant et l'**ID de transaction** (reçu par SMS).
2. Le créateur voit le versement dans **Projets partagés → son projet → Versements à valider** (et une pastille sur l'accueil). Il compare avec son SMS puis **Valide** ou **Refuse** (avec motif).
3. Un versement validé est ajouté **à la caisse du créateur** (source « Don ») puis **au projet** : la caisse reste équilibrée et l'historique garde la trace. Le montant de la page publique et la liste « Contributions par membre » se mettent à jour.
4. Un même ID de transaction ne peut pas être déclaré deux fois dans un projet (sauf s'il a été refusé).
> L'app ne déplace pas d'argent : le versement se fait par l'opérateur, Tirelire sert à le déclarer, le valider et le comptabiliser.
