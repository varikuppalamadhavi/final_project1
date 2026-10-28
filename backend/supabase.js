const { createClient } = require('@supabase/supabase-js');
const url = process.env.SUPABASE_URL;
const key = process.env.SUPABASE_SERVICE_ROLE_KEY;
if (!url || !key) console.warn('Supabase credentials are missing. Configure backend/.env before using database features.');
const supabase = url && key ? createClient(url,key,{auth:{persistSession:false,autoRefreshToken:false}}) : null;
module.exports = supabase;
