server {
    listen      %ip%:%proxy_port%;
    server_name %domain_idn% %alias_idn%;
    error_log  /var/log/%web_system%/domains/%domain%.error.log error;

    location / {
        proxy_pass      http://%ip%:%web_port%;
        location ~* ^.+\.(%proxy_extentions%)$ {
            root           %docroot%;
            access_log     /var/log/%web_system%/domains/%domain%.log combined;
            access_log     /var/log/%web_system%/domains/%domain%.bytes bytes;
            expires        max;
            try_files      $uri @fallback;
        }
    }

    location /error/ {
        alias   %home%/%user%/web/%domain%/document_errors/;
    }

    location @fallback {
        proxy_pass      http://%ip%:%web_port%;
    }

    location ~ /\.ht    {return 404;}
    location ~ /\.svn/  {return 404;}
    location ~ /\.git/  {return 404;}
    location ~ /\.hg/   {return 404;}
    location ~ /\.bzr/  {return 404;}

    pagespeed On;
    #pagespeed Off;
    pagespeed RewriteLevel PassThrough;
    pagespeed FileCachePath /var/cache/pagespeed;

    ## Text / HTML
    #Удаляет излишки пробелы в HTML - файлах
    #pagespeed EnableFilters collapse_whitespace;
    #pagespeed EnableFilters convert_meta_tags;
    #pagespeed EnableFilters elide_attributes;
    #pagespeed EnableFilters remove_comments;
    #pagespeed EnableFilters remove_quotes;

    ## JavaScript
    pagespeed EnableFilters combine_javascript;
    pagespeed EnableFilters inline_javascript;

    ## CSS
    pagespeed EnableFilters outline_css;
    pagespeed EnableFilters combine_css;
    pagespeed EnableFilters inline_import_to_link;
    pagespeed EnableFilters inline_css;
    pagespeed EnableFilters inline_google_font_css;
    pagespeed EnableFilters move_css_above_scripts;
    #pagespeed EnableFilters move_css_to_head;
    #pagespeed EnableFilters prioritize_critical_css;
    pagespeed EnableFilters rewrite_css;
    pagespeed EnableFilters fallback_rewrite_css_urls;
    #pagespeed EnableFilters rewrite_style_attributes_with_url;

    ## Images
    pagespeed EnableFilters resize_mobile_images;
    pagespeed EnableFilters lazyload_images;
    #pagespeed EnableFilters convert_gif_to_png;
    pagespeed EnableFilters convert_jpeg_to_progressive;
    pagespeed EnableFilters recompress_jpeg;
    pagespeed EnableFilters recompress_png;
    pagespeed EnableFilters recompress_webp;
    #pagespeed EnableFilters strip_image_color_profile;
    #pagespeed EnableFilters strip_image_meta_data;
    #pagespeed EnableFilters convert_png_to_jpeg;
    #pagespeed EnableFilters resize_images;
    #pagespeed EnableFilters resize_rendered_image_dimensions;
    pagespeed EnableFilters convert_jpeg_to_webp;
    #pagespeed EnableFilters convert_to_webp_lossless;
    #pagespeed EnableFilters insert_image_dimensions;
    #pagespeed EnableFilters make_google_analytics_async;

    ## Miscellaneous
    pagespeed EnableFilters add_instrumentation;
    pagespeed EnableFilters insert_dns_prefetch;

    ## Cache
    pagespeed EnableFilters extend_cache;
    pagespeed EnableFilters extend_cache_pdfs;
    pagespeed EnableFilters local_storage_cache;

    pagespeed JpegRecompressionQuality 85;
    pagespeed ImageRecompressionQuality 85;


    # Максимальный размер кэша
    pagespeed FileCacheSizeKb 102400;
    # Интервал для очистки кэша
    pagespeed FileCacheCleanIntervalMs 360000;
    # Максимальное количество дескрипторов
    pagespeed FileCacheInodeLimit 500000;

    
    pagespeed Statistics                     on;
    pagespeed StatisticsLogging              on;
    pagespeed StatisticsLoggingIntervalMs    60000;
    pagespeed StatisticsLoggingMaxFileSizeKb 1024;
    
    location ~ ^/pagespeed_admin {
      allow 127.0.0.1;
      deny all;
    }

    location ~ "\.pagespeed\.([a-z]\.)?[a-z]{2}\.[^.]{10}\.[^.]+" { add_header "" ""; }
    location ~ "^/pagespeed_static/" { }
    location ~ "^/ngx_pagespeed_beacon$" { }

    include %home%/%user%/conf/web/nginx.%domain%.conf*;
}

