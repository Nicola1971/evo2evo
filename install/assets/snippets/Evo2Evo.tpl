/**
 * Evo2Evo
 *
 * <b>1.0</b> Display Content from remote MODX 
 *
 * @category	snippet
 * @version    1.0
 * @author      Author: Nicola Lambathakis http://www.tattoocms.it/
 * @internal	@modx_category Content
 * @license 	http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 */

/**
 * Evo2Evo
 * Display Content from remote MODX Evolution
 * 
 * @category    snippet
 * @version    1.0
 * @internal @modx_category    Content

 */
 /**
Display content from document id 32 with db info parameters
[!Evo2Evo? &id=`32` &evoTpl=`evoTpl` &db_hostname=`localhost` &db_username=`root` &db_password=`` &db_database=`revolution`!]

Display content from document id 32 using db info hardcoded in snippet code
[!Evo2Evo? &id=`32` &evoTpl=`evoTpl`]

Display content from document id 32 and value from template variable id 2 
[!Evo2Evo? &id=`32` &TvId=`2` &evoTpl=`evoTpl`!]

Display content from document id 32, value from image template variable id 2 and fetch image function (image will be copied from remote modx in to local folder assets/images/evo2evo)
[!Evo2Evo? &id=`32` &TvId=`2` &evoTpl=`evoTpl` &fetchimages=`1` &store_dir=`assets/images/evo2evo`!]
**/


if(!defined('MODX_BASE_PATH')){die('What are you doing? Get out of here!');}
	/*remote modx db login*/
$db_hostname  = (isset($db_hostname)) ? $db_hostname : 'localhost';
$db_username  = (isset($db_username)) ? $db_username : 'root';
$db_password  = (isset($db_password)) ? $db_password : '';
$db_database  = (isset($orderdir)) ? $orderdir : 'evolution';
$evo_url = (isset($evo_url)) ? $evo_url : 'http://localhost/evolution';

	/*define snippet params*/
$evoTpl = (isset($evoTpl)) ? $evoTpl : $evoTpl;
$TvId = (isset($TvId)) ? $TvId : '';
$orderdir = (isset($orderdir)) ? $orderdir : 'DESC';
$orderby = (isset($orderby)) ? $orderby : 'id';
$trim = (isset($trim)) ? $trim : '200';
$noResults = (isset($noResults)) ? $noResults : 'No content found';
$fetchimages = (isset($fetchimages)) ? $fetchimages : '0'; 
$store_dir = (isset($store_dir)) ? $store_dir : 'assets/images/evo2evo';
$store_dir_type = (isset($store_dir_type)) ? $store_dir_type : 'relative';
$overwrite = (isset($overwrite)) ? $overwrite : 'false';
$pref = (isset($pref)) ? $pref : 'false';
$debug = (isset($debug)) ? $debug : 'true';
if ($TvId != '') { 
    $andTV = 'AND modx_site_tmplvar_contentvalues.tmplvarid = '.$TvId.''; 
}
else {$andTV = ''; }
global $modx;

include_once(MODX_BASE_PATH . 'assets/snippets/evo2evo/evo2evo.functions.php');  

$db_server = new mysqli($db_hostname,$db_username,$db_password,$db_database); 
if (mysqli_connect_errno()) { 
    printf("Can't connect to MySQL Server. Errorcode: %s\n", mysqli_connect_error()); 
    exit; 
} 

$result0 = mysqli_query($db_server, "SELECT DISTINCT 
modx_site_content.id, modx_site_content.pagetitle, modx_site_content.longtitle, modx_site_content.description, modx_site_content.alias, modx_site_content.introtext, modx_site_content.content, modx_site_content.menutitle,modx_site_content.published,modx_site_content.description,
modx_site_tmplvar_contentvalues.contentid, modx_site_tmplvar_contentvalues.tmplvarid, modx_site_tmplvar_contentvalues.value
FROM modx_site_content 
LEFT JOIN modx_site_tmplvar_contentvalues ON modx_site_tmplvar_contentvalues.contentid=modx_site_content.id 
WHERE modx_site_content.id IN ($id) 
$andTV
GROUP BY modx_site_content.id
ORDER BY modx_site_content.$orderby $orderdir")
or die(mysqli_error($db_server)); if (!$result0) die ("Database access failed: " . mysqli_error());

if ( mysqli_num_rows( $result0 ) < 1 )
{
     echo" $noResults";
}
else
{
	
while($row0 = mysqli_fetch_array( $result0 )) {
	$docid = $row0['id'];	  
	$pagetitle = $row0['pagetitle'];
	$longtitle = $row0['longtitle'];
	$description = $row0['description'];
	$alias = $row0['alias'];
	$introtext = $row0['introtext'];
	$menutitle = $row0['menutitle'];
	$alias = $row0['alias'];
    $content = $row0['content'];
    $decoded_content = html_entity_decode($content);
	$flat_content = strip_tags($decoded_content);
	$short_content = substrwords($flat_content,$trim);
	$full_content = str_replace('assets/images',''.$evo_url.'/assets/images',$content);    
    $tvvalue = $row0['value'];
	$tmplvarid = $row0['tmplvarid'];

	    $tvimage = $row0['value'];
		$remote_image = "$evo_url/$tvimage";
		if($fetchimages == '0') {
	$imagetv = $remote_image;
	}
	else 
	if($fetchimages == '1') {
	$imagetv = itg_fetch_image($remote_image, $store_dir, $store_dir_type, $overwrite, $pref, $debug);
    }


// parse the chunk and replace the placeholder values.
// placeholderName => placeholderValue
$values = array('docid' => $docid, 'pagetitle' => $pagetitle, 'longtitle' => $longtitle, 'description' => $description, 'alias' => $alias, 'introtext' => $introtext, 'content' => $content, 'decoded_content' => $decoded_content, 'flat_content' => $flat_content, 'short_content' => $short_content,'full_content' => $full_content,'menutitle' => $menutitle, 'tvvalue' => $tvvalue,'tmplvarid' => $tmplvarid,'imagetv' => $imagetv);

$output =  $output . $modx->parseChunk($evoTpl, $values, '[+', '+]');

	}
}//end while
mysqli_close($db_server);


return $output;
?>