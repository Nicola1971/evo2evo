# evo2evo
MODX Evolution Snippet to Display Content from a remote MODX Evolution (or Revolution)


##Example calls

Display content from document id 32 with db info parameters

```[!Evo2Evo? &id=`32` &evoTpl=`evoTpl` &db_hostname=`localhost` &db_username=`root` &db_password=`` &db_database=`evolution`!]```

Display content from document id 32 using db info hardcoded in snippet code

```[!Evo2Evo? &id=`32` &evoTpl=`evoTpl`]```

Display content from document id 32 and value from template variable id 2 

```[!Evo2Evo? &id=`32` &TvId=`2` &evoTpl=`evoTpl`!]```

Display content from document id 32, value from image template variable id 2 and fetch image function (image will be copied from remote modx in to local folder assets/images/evo2evo)

```[!Evo2Evo? &id=`32` &TvId=`2` &evoTpl=`evoTpl` &fetchimages=`1` &store_dir=`assets/images/evo2evo`!]```


## basic parameters

* &db_hostname, &db_username, &db_password, &db_database = remote modx db credentials
* &evo_url = remote modx site url
* &evoTpl = default display template
* &TvId = template variable id 
* &trim = trim content lenght (default 200) for short_content placeholder
* &fetchimages = fetch remote tv image in your modx images folder (default 0 : not fetch)
* &store_dir = folder where store remote tv images (default assets/images/evo2evo)

##tpl placeholders

* docid = id
* pagetitle
* longtitle
* description
* alias
* introtext
* menutitle
* content
* decoded_content = html_entity_decode content
* flat_content = strip_tags decoded_content
* short_content = trimmed version of flat_content 
* full_content = full content with images (remote modx site url (&evo_url) is added to remote images path to avoid broken images) 
* tvvalue =  value of template variable (&tvId)
* imagetv = image template variable (&tvId)

