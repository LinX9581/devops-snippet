//BEGIN 限定建立特定分類文章 ex. ilook電影、校園
function restrict_categories($categories)
{
    global $pagenow;
    if (!current_user_can('level_10') && in_array($pagenow, ['post.php', 'post-new.php', 'edit.php'])) {
        if (current_user_can('_create_campus_post_only') or current_user_can('_create_ilook_post_only')) {
            $size = count($categories);
            for ($i = 0; $i < $size; $i++) {
                // restrict the categories for campus only by ID
                if (current_user_can('_create_campus_post_only')) {
                    if ($categories[$i]->taxonomy == 'category') {
                        $category = 155695;
                        if ($categories[$i]->term_id != $category && $categories[$i]->parent != $category) {
                            unset($categories[$i]);
                        }
                    }
                }

                // restrict the categories for ilook only by ID
                if (current_user_can('_create_ilook_post_only')) {
                    if ($categories[$i]->taxonomy == 'category') {
                        $category = 173800;
                        if ($categories[$i]->term_id != $category && $categories[$i]->parent != $category) {
                            unset($categories[$i]);
                        }
                    }
                }
            }
            return $categories;
        }
        return $categories;
    }
    return $categories;
}

add_filter('get_terms', 'restrict_categories');
//END 限定建立特定分類文章