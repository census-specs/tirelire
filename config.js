/* Tirelire — configuration (un seul endroit pour l'app ET la page publique des projets partagés)
   Supabase → Project Settings → API : « Project URL » et clé « publishable » (ou « anon public »).
   Cette clé est faite pour être publique ; jamais la clé « secret » / « service_role ». */
window.TIRELIRE_CONFIG = {
  url: 'https://ezbzdevqutlmniultomy.supabase.co',
  key: 'sb_publishable_y83V1OV0Yj5kRETZkF9PCQ_ptxJw9hJ',
  appUrl: 'https://tirelire-pi.vercel.app'   // adresse publique de l'app
};
