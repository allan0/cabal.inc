// supabase/functions/news-proxy/index.ts

import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { corsHeaders } from '../_shared/cors.ts' // Import the shared headers

const NEWS_RSS_URL = 'https://thedefiant.io/feed'; // The RSS feed you want to proxy

serve(async (req) => {
  // This is new: handle CORS preflight requests
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Fetch the RSS feed from the origin server
    const response = await fetch(NEWS_RSS_URL);
    if (!response.ok) {
      throw new Error(`Failed to fetch RSS feed: ${response.statusText}`);
    }
    const feedText = await response.text();

    // Return the feed content with CORS headers
    return new Response(feedText, {
      headers: { ...corsHeaders, 'Content-Type': 'application/xml' },
      status: 200,
    });
    
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 500,
    })
  }
})
