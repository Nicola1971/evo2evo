<?php
if(!function_exists('substrwords')) {	
function substrwords($text, $maxchar, $end='...') {
    if (strlen($text) > $maxchar || $text == '') {
        $words = preg_split('/\s/', $text);      
        $output = '';
        $i      = 0;
        while (1) {
            $length = strlen($output)+strlen($words[$i]);
            if ($length > $maxchar) {
                break;
            } 
            else {
                $output .= " " . $words[$i];
                ++$i;
            }
        }
        $output .= $end;
    } 
    else {
        $output = $text;
    }
    return $output;
}
}

/**********************/
/*
Funcion fetch images 
	credits: 
http://www.intechgrity.com/automatically-copy-images-png-jpeg-gif-from-remote-server-http-to-your-local-server-using-php/#
*/
if(!function_exists('itg_fetch_image')) {		
function itg_fetch_image($img_url, $store_dir, $store_dir_type, $overwrite, $pref, $debug) {
    //first get the base name of the image
    $i_name = explode('.', basename($img_url));
    $i_name = $i_name[0];
	
		    //second get the dir name of the image
    $i_path = explode('.', dirname($img_url));
    $i_path = $i_path[0];
	$subfolders = explode('/', $i_path);
	
	$urlparts = parse_url($img_url);
$remotepath = $urlparts['path'].'?'.$urlparts['query'];
	
	
     //now try to guess the image type from the given url
    //it should end with a valid extension...
    //good for security too
    if(preg_match('/https?:\/\/.*\.png$/i', $img_url)) {
        $img_type = 'png';
    }
    else if(preg_match('/https?:\/\/.*\.(jpg|jpeg)$/i', $img_url)) {
        $img_type = 'jpg';
    }
    else if(preg_match('/https?:\/\/.*\.gif$/i', $img_url)) {
        $img_type = 'gif';
    }
    else {
        if(true == $debug)
            echo ''.$oclocal_image,' Invalid image URL';
        return ''; //possible error on the image URL
    }
 
    $dir_name = (($store_dir_type == 'relative')? './' : '') . rtrim($store_dir, '/') . '/';
 
     //create the directory if not present
    if(!file_exists($dir_name))
        mkdir($dir_name, 0777, true);
 
    //calculate the destination image path
    $i_dest = $dir_name . $i_name . (($pref === false)? '' : '_' . $pref) . '.' . $img_type;
	
    //lets see if the path exists already
    if(file_exists($i_dest)) {
        $pref = (int) $pref;
 
        //modify the file name, do not overwrite
        if(rename == $overwrite)
				
			  return itg_fetch_image($img_url, $store_dir, $store_dir_type, $overwrite, ++$pref, $debug);
		
		 else if(false == $overwrite) {
         echo '';
    }
        //delete & overwrite
        else
            unlink ($i_dest);
    }
 
    //first check if the image is fetchable
    $img_info = @getimagesize($img_url);
 
    //is it a valid image?
    if(false == $img_info || !isset($img_info[2]) || !($img_info[2] == IMAGETYPE_JPEG || $img_info[2] == IMAGETYPE_PNG || $img_info[2] == IMAGETYPE_JPEG2000 || $img_info[2] == IMAGETYPE_GIF)) {
        if(true == $debug)
            echo 'The image doesn\'t seem to exist in the remote server';
        return ''; //return empty string
    }
 
    //now try to create the image
    if($img_type == 'jpg') {
        $m_img = @imagecreatefromjpeg($img_url);
    } else if($img_type == 'png') {
        $m_img = @imagecreatefrompng($img_url);
        @imagealphablending($m_img, false);
        @imagesavealpha($m_img, true);
    } else if($img_type == 'gif') {
        $m_img = @imagecreatefromgif($img_url);
    } else {
        $m_img = FALSE;
    }
 
    //was the attempt successful?
    if(FALSE === $m_img) {
        if(true == $debug)
            echo 'Can not create image from the URL';
        return '';
    }
 
    //now attempt to save the file on local server
    if($img_type == 'jpg') {
        if(imagejpeg($m_img, $i_dest, 100))
            return $i_dest;
        else
            return '';
    } else if($img_type == 'png') {
        if(imagepng($m_img, $i_dest, 0))
            return $i_dest;
        else
            return '';
    } else if($img_type == 'gif') {
        if(imagegif($m_img, $i_dest))
            return $i_dest;
        else
            return '';
    }
 
    return '';
}
	}
//end fetch images
/*****************/


?>