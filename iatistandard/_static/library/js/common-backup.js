jQuery(document).ready(function($) {

    //Placeholder support for old browsers...
    var $searchInput = $('#s');
    $searchInput.addClass('light');
    var searchPlaceHolder = $searchInput.attr('placeholder');
    $('#s').val(searchPlaceHolder)
        .focus(
        function(){
            if( this.value == searchPlaceHolder ){
                this.value='';
                $(this).removeClass('light');
            }
        }).blur(function(){
            if( this.value == '' ){
                $(this).val(searchPlaceHolder).addClass('light');
            }
        }
    );

    //Fix the vertical dividers in the main nav...
    $('ul.menu-main').on('hover', 'li', function(){
        //Get proceeding link...
        var $leftAdjacent = $(this).prev();
        if($leftAdjacent.length = 1){
            $leftAdjacent.toggleClass('left-adjacent');
        }
    });


    //Side menu
    var toggleSubMenus = function(ele){
        $(ele).toggle();
        var toggle = $(ele).siblings('span.toggle');
        changeToggleImage(toggle);
    };

    var changeToggleImage = function(ele){
        $toggleImage = $(ele).find('img');
        $toggleImage.toggleClass('open');
        var updateToggleImagePath = toggleImgPath;
        if( $toggleImage.hasClass('open') ){
            updateToggleImagePath = toggleImgPathOpen;
        };
        $toggleImage.attr('src', updateToggleImagePath );
    };

    //Set root
    $('aside.widget_pages > ul').addClass('pages-root');
    //Find all pages with children and paint them
    $('aside.widget_pages ul.children').closest('li').addClass('page-has-children');
    //Paint levels
    $('aside.widget_pages > ul.pages-root> li').addClass('level-0');

    //Add toggles to pages with submenus
    var toggleImgPath = IATIStandard.themePath + "/library/images/icons/arrows-theme-accent-right.png";
    var toggleImgPathOpen = IATIStandard.themePath + "/library/images/icons/arrows-theme-accent-down.png";

    //Add toggles to all li with submenus
    $('li.page-has-children').each(function(i){
        var $toggleImage = $('<img src="' + toggleImgPath + '" alt="Click to expand"/>');
        var $toggle = $('<span class="toggle"></span>');
        $toggle.prepend($toggleImage);
        $(this).prepend($toggle);
    });

    //Setup the initial menu state...
    $('aside.widget_pages ul.children').hide();
    var $currentPage = $('li.current_page_item');
    var $thisSubMenu = $currentPage.find('ul.children').first();
    $currentPage.parents('ul.children').add($thisSubMenu).each( function(){
        toggleSubMenus(this);
    });

    // Event handlers for the toggles
    $('aside.widget_pages ul').on('click', 'span.toggle' , function(){
        //Open close the child uls
        $(this).parent().find('ul.children').first().toggle().toggleClass('open');
        //change toggle images according to state..
        changeToggleImage(this);
        return false;
    });
    //Equalise height of Home Page Icons
    IatiJS.Utilities.equaliseHeight($('#home-icon-panels div.icon'));

});
