#!/bin/sh

# language selection
# based on https://unix.stackexchange.com/questions/43976/list-all-valid-kbd-layouts-variants-and-toggle-options-to-use-with-setxkbmap
# rev. 2021-03-07

DIA_KBD_LANG="us  USA
	ad  Andorra
	af  Afghanistan
	ara Arabic
	al  Albania
	am  Armenia
	az  Azerbaijan
	by  Belarus
	be  Belgium
	bd  Bangladesh
	in  India
	ba  Bosnia_Herzegovina
	br  Brazil
	bg  Bulgaria
	ma  Morocco
	mm  Myanmar
	ca  Canada
	cd  Congo
	cn  China
	hr  Croatia
	cz  Czechia
	dk  Denmark
	nl  Netherlands
	bt  Bhutan
	ee  Estonia
	ir  Iran
	iq  Iraq
	fo  Faroe_Islands
	fi  Finland
	fr  France
	gh  Ghana
	gn  Guinea
	ge  Georgia
	de  Germany
	gr  Greece
	hu  Hungary
	is  Iceland
	il  Israel
	it  Italy
	jp  Japan
	kg  Kyrgyzstan
	kh  Cambodia
	kz  Kazakhstan
	la  Laos
	lt  Lithuania
	lv  Latvia
	me  Montenegro
	mk  Macedonia
	mt  Malta
	mn  Mongolia
	no  Norway
	pl  Poland
	pt  Portugal
	ro  Romania
	ru  Russia
	rs  Serbia
	si  Slovenia
	sk  Slovakia
	es  Spain
	se  Sweden
	ch  Switzerland
	sy  Syria
	tj  Tajikistan
	lk  Sri_Lanka
	th  Thailand
	tr  Turkey
	tw  Taiwan
	ua  Ukraine
	gb  United_Kingdom
	uz  Uzbekistan
	vn  Vietnam
	kr  Korea
	ie  Ireland
	pk  Pakistan
	mv  Maldives
	za  South_Africa
	np  Nepal
	ng  Nigeria
	et  Ethiopia
	sn  Senegal
	tm  Turkmenistan
	ml  Mali
	tz  Tanzania"
	
DIA_KBD_VAR_us="chr            	us_Cherokee
	euro           	us_EuroSign
	intl           	us_international_deadkeys
	alt-intl       	us_international_alternative
	colemak        	us_Colemak
	dvorak         	us_Dvorak
	dvorak-intl    	us_Dvorak_international
	dvorak-l       	us_Dvorak_lefthanded
	dvorak-r       	us_Dvorak_righthanded
	dvorak-classic 	us_Dvorak_classic
	dvp            	us_Dvorak_programmer
	rus            	us_Russian
	mac            	us_Macintosh
	altgr-intl     	us_international_AltGr
	olpc2          	us_GroupToggle(divide)
	srp            	us_Serbian"

DIA_KBD_VAR_af="ps             af_Pashto
	uz             af_Southern_Uzbek
	olpc-ps        af_OLPC_Pashto
	olpc-fa        af_OLPC_Dari
	olpc-uz        af_OLPC_Uzbek"

DIA_KBD_VAR_ara="azerty         ara_azerty
	azerty_digits  ara_azerty/digits
	digits         ara_digits
	qwerty         ara_qwerty
	qwerty_digits  ara_qwerty/digits
	buckwalter     ara_Buckwalter"

DIA_KBD_VAR_am="phonetic       am_Phonetic
	phonetic-alt   am_Alternative_Phonetic
	eastern        am_Eastern
	western        am_Western
	eastern-alt    am_Alternative_Eastern"

DIA_KBD_VAR_az="cyrillic       az_Cyrillic"

DIA_KBD_VAR_by="legacy         by_Legacy
	latin          by_Latin"

DIA_KBD_VAR_be="oss            	be_Alternative
	oss_latin9     	be_Alternative_Latin9
	iso-alternate  	be_ISO_Alternate
	nodeadkeys     	be_nodeadkeys
	wang           	be_Wang724_azerty"

DIA_KBD_VAR_bd="probhat        bd_Probhat"

DIA_KBD_VAR_in="ben            in_Bengali
	ben_probhat    in_Bengali_Probhat
	guj            in_Gujarati
	guru           in_Gurmukhi
	jhelum         in_Gurmukhi_Jhelum
	kan            in_Kannada
	mal            in_Malayalam
	mal_lalitha    in_Malayalam_Lalitha
	ori            in_Oriya
	tam_unicode    in_Tamil_Unicode
	tam_TAB        in_Tamil_TAB_Typewriter
	tam_TSCII      in_Tamil_TSCII_Typewriter
	tam            in_Tamil
	tel            in_Telugu
	urd-phonetic   in_Urdu_Phonetic
	urd-phonetic3  in_Urdu_Phonetic_alternative
	urd-winkeys    in_Urdu_Winkeys
	bolnagri       in_Hindi_Bolnagri
	hin-wx         in_Hindi_Wx"

DIA_KBD_VAR_ba="unicode        ba_digraphs
	unicodeus      ba_US_digraphs
	us             ba_US_letters"

DIA_KBD_VAR_br="nodeadkeys     br_nodeadkeys
	dvorak         br_Dvorak
	nativo         br_Nativo
	nativo-us      br_Nativo_USA
	nativo-epo     br_Nativo_Esperanto"

DIA_KBD_VAR_bg="phonetic       bg_phonetic_traditional
	bas_phonetic   bg_phonetic_new"

DIA_KBD_VAR_ma="french         				ma_French
	tifinagh       				ma_Tifinagh
	tifinagh-alt   				ma_Tifinagh_alternative
	tifinagh-alt-phonetic		ma_Tifinagh_alternative_phonetic
	tifinagh-extended			ma_Tifinagh_extended
	tifinagh-phonetic			ma_Tifinagh_phonetic
	tifinagh-extended-phonetic	ma_Tifinagh_extended_phonetic"

DIA_KBD_VAR_ca="fr-dvorak      ca_French_Dvorak
	fr-legacy      ca_French_legacy
	multix         ca_Multilingual
	multi          ca_Multilingual_part1
	multi-2gr      ca_Multilingual_part2
	ike            ca_Inuktitut
	shs            ca_Secwepemctsin
	kut            ca_Ktunaxa
	eng            ca_English"

DIA_KBD_VAR_cn="tib            cn_Tibetan
	tib_asciinum   cn_Tibetan_ASCII_numerals"

DIA_KBD_VAR_hr="unicode        hr_Croatian_digraphs
	unicodeus      hr_US_Croatian_digraphs
	us             hr_US_Croatian_letters"

DIA_KBD_VAR_cz="bksl           cz_pointy_brackets
	qwerty         cz_qwerty
	qwerty_bksl    cz_qwerty_backslash
	ucw            cz_UCW
	dvorak-ucw     cz_US_UCW_Dvorak"

DIA_KBD_VAR_dk="nodeadkeys     	dk_nodeadkeys
	mac            	dk_Macintosh
	mac_nodeadkeys 	dk_Macintosh_nodeadkeys
	dvorak         	dk_Dvorak"

DIA_KBD_VAR_nl="mac            nl_Macintosh
	std            nl_Standard"

DIA_KBD_VAR_ee="nodeadkeys     ee_nodeadkeys
	dvorak         ee_Dvorak
	us             ee_US"

DIA_KBD_VAR_ir="pes_keypad     ir_Persian
	ku             ir_Kurdish_Q
	ku_f           ir_Kurdish_F
	ku_alt         ir_Kurdish_AltQ
	ku_ara         ir_Kurdish_Arabic"

DIA_KBD_VAR_iq="ku             iq_Kurdish_Q
	ku_f           iq_Kurdish_F
	ku_alt         iq_Kurdish_AltQ
	ku_ara         iq_Kurdish_Arabic"

DIA_KBD_VAR_fo="nodeadkeys     fo_nodeadkeys"

DIA_KBD_VAR_fi="nodeadkeys     fi_nodeadkeys
	smi            fi_Saami
	classic        fi_Classic
	mac            fi_Macintosh"

DIA_KBD_VAR_fr="nodeadkeys     	fr_nodeadkeys
	oss            	fr_Alternative
	oss_latin9     	fr_Alternative_Latin9
	oss_nodeadkeys 	fr_Alternative_nodeadkeys
	bepo           	fr_Bepo_Dvorak_ergo
	bepo_latin9    	fr_Bepo_Dvorak_Latin9
	dvorak         	fr_Dvorak
	mac            	fr_Macintosh
	bre            	fr_Breton
	oci            	fr_Occitan
	geo            	fr_Georgian_AZERTY"

DIA_KBD_VAR_gh="generic        gh_Multilingual
	akan           gh_Akan
	ewe            gh_Ewe
	fula           gh_Fula
	ga             gh_Ga
	hausa          gh_Hausa"

DIA_KBD_VAR_ge="ergonomic      ge_Ergonomic
	mess           ge_MESS
	ru             ge_Russian
	os             ge_Ossetian"

DIA_KBD_VAR_de="deadacute      	de_DeadAcute
	deadgraveacute 	de_DeadGraveAcute
	nodeadkeys     	de_nodeadkeys
	ro             	de_Romanian
	ro_nodeadkeys  	de_Romanian_nodeadkeys
	dvorak         	de_Dvorak
	neo            	de_Neo2
	mac            	de_Macintosh
	mac_nodeadkeys 	de_Macintosh_nodeadkeys
	dsb            	de_Sorbian
	dsb_qwertz     	de_Sorbian_qwertz
	qwerty         	de_qwerty"

DIA_KBD_VAR_gr="simple         gr_Simple
	extended       gr_Extended
	nodeadkeys     gr_nodeadkeys
	polytonic      gr_Polytonic"

DIA_KBD_VAR_hu="standard       hu_Standard
	nodeadkeys     hu_nodeadkeys
	qwerty         hu_qwerty"

DIA_KBD_VAR_is="nodeadkeys     is_nodeadkeys
	mac            is_Macintosh
	dvorak         is_Dvorak"

DIA_KBD_VAR_il="lyx            il_lyx
	phonetic       il_Phonetic
	biblical       il_Biblical_Hebrew"

DIA_KBD_VAR_it="nodeadkeys     it_nodeadkeys
	mac            it_Macintosh
	us             it_US
	geo            it_Georgian"

DIA_KBD_VAR_jp="kana           jp_Kana
	OADG109A       jp_OADG 109A
	mac            jp_Macintosh"

DIA_KBD_VAR_kg="phonetic       kg_Phonetic"

DIA_KBD_VAR_kz="ruskaz         kz_Russian_Kazakh
	kazrus         kz_Kazakh_Russian"

DIA_KBD_VAR_la="basic          la_Laos
	stea           la_Laos_STEA"

DIA_KBD_VAR_lt="std            lt_Standard
	us             lt_US
	ibm            lt_IBM
	lekp           lt_LEKP
	lekpa          lt_LEKPa"

DIA_KBD_VAR_lv="apostrophe     lv_Apostrophe
	tilde          lv_Tilde
	fkey           lv_F"

DIA_KBD_VAR_me="cyrillic       	me_Cyrillic
	cyrillicyz     	me_Cyrillic_Z/ZHE_swapped
	latinunicode   	me_Latin_unicode
	latinyz        	me_Latin_qwerty
	latinunicodeyz 	me_Latin_unicode_qwerty"

DIA_KBD_VAR_mk="nodeadkeys     mk_nodeadkeys"

DIA_KBD_VAR_mt="us             mt_US"

DIA_KBD_VAR_no="nodeadkeys     	no_nodeadkeys
	dvorak         	no_Dvorak
	smi            	no_Saami
	smi_nodeadkeys 	no_Saami_nodeadkeys
	mac            	no_Macintosh
	mac_nodeadkeys 	no_Macintosh_nodeadkeys"

DIA_KBD_VAR_pl="qwertz         		pl_qwertz
	dvorak         		pl_Dvorak
	dvorak_quotes  		pl_Dvorak_Quotes
	dvorak_altquotes	pl_Dvorak_Quotes1
	csb            		pl_Kashubian
	ru_phonetic_dvorak	pl_Dvorak_Russian
	dvp            		pl_Dvorak_Programmer"

DIA_KBD_VAR_pt="nodeadkeys     	pt_nodeadkeys
	mac            	pt_Macintosh
	mac_nodeadkeys 	pt_Macintosh_nodeadkeys
	nativo         	pt_Nativo
	nativo-us      	pt_Nativo_USA
	nativo-epo     	pt_Nativo_Esperanto"

DIA_KBD_VAR_ro="cedilla        ro_Cedilla
	std            ro_Standard
	std_cedilla    ro_Standard_Cedilla
	winkeys        ro_Winkeys
	crh_f          ro_CrimeanTatar_F
	crh_alt        ro_CrimeanTatar_AltQ
	crh_dobruca1   ro_CrimeanTatar_Dobruca1
	crh_dobruca2   ro_CrimeanTatar_Dobruca2"

DIA_KBD_VAR_ru="phonetic       		ru_Phonetic
	phonetic_winkeys	ru_Phonetic_Winkeys
	typewriter     		ru_Typewriter
	legacy         		ru_Legacy
	typewriter-legacy	ru_Typewriter_legacy
	tt             		ru_Tatar
	os_legacy      		ru_Ossetian_legacy
	os_winkeys     		ru_Ossetian_Winkeys
	cv             		ru_Chuvash
	cv_latin       		ru_Chuvash_Latin
	udm            		ru_Udmurt
	kom            		ru_Komi
	sah            		ru_Yakut
	xal            		ru_Kalmyk
	dos            		ru_DOS
	srp            		ru_Serbian
	bak            		ru_Bashkirian"

DIA_KBD_VAR_rs="yz             	rs_Z/ZHE_swapped
	latin          	rs_Latin
	latinunicode   	rs_Latin_Unicode
	latinyz        	rs_Latin_qwerty
	latinunicodeyz 	rs_Latin_Unicode_qwerty"

DIA_KBD_VAR_si="us             si_US"

DIA_KBD_VAR_sk="bksl           sk_ExtendedBackslash
	qwerty         sk_qwerty
	qwerty_bksl    sk_qwerty_ExtendedBackslash"

DIA_KBD_VAR_es="nodeadkeys     es_nodeadkeys
	deadtilde      es_deadtilde
	dvorak         es_Dvorak
	ast            es_Asturian
	cat            es_Catalan
	mac            es_Macintosh"

DIA_KBD_VAR_se="nodeadkeys     	se_nodeadkeys
	dvorak         	se_Dvorak
	rus            	se_Russian_phonetic
	rus_nodeadkeys 	se_Russian_phonetic_nodeadkeys
	smi            	se_Saami
	mac            	se_Macintosh
	svdvorak       	se_Svdvorak"

DIA_KBD_VAR_ch="legacy         ch_Legacy
	de_nodeadkeys  ch_German_nodeadkeys
	fr             ch_French
	fr_nodeadkeys  ch_French_nodeadkeys
	fr_mac         ch_French_Macintosh
	de_mac         ch_German_Macintosh"

DIA_KBD_VAR_sy="syc            sy_Syriac
	syc_phonetic   sy_Syriac_phonetic
	ku             sy_Kurdish_Q
	ku_f           sy_Kurdish_F
	ku_alt         sy_Kurdish_AltQ"

DIA_KBD_VAR_lk="tam_unicode    lk_Tamil_Unicode
	tam_TAB        lk_Tamil_Typewriter"

DIA_KBD_VAR_th="tis            th_TIS-820.2538
	pat            th_Pattachote"

DIA_KBD_VAR_tr="f              tr_F
	alt            tr_AltQ
	ku             tr_Kurdish_Q
	ku_f           tr_Kurdish_F
	ku_alt         tr_Kurdish_AltQ
	intl           tr_International_deadkeys
	crh            tr_CrimeanTatar_Q
	crh_f          tr_CrimeanTatar_F
	crh_alt        tr_CrimeanTatar_AltQ"

DIA_KBD_VAR_tw="indigenous     tw_Indigenous
	saisiyat       tw_Saisiyat"

DIA_KBD_VAR_ua="phonetic       ua_Phonetic
	typewriter     ua_Typewriter
	winkeys        ua_Winkeys
	legacy         ua_Legacy
	rstu           ua_Standard_RSTU
	rstu_ru        ua_Standard_RSTU_Russian
	homophonic     ua_Homophonic
	crh            ua_CrimeanTatar_Q
	crh_f          ua_CrimeanTatar_F
	crh_alt        ua_CrimeanTatar_AltQ"

DIA_KBD_VAR_gb="extd           gb_Winkeys
	intl           gb_International_deadkeys
	dvorak         gb_Dvorak
	dvorakukp      gb_Dvorak_UK
	mac            gb_Macintosh
	colemak        gb_Colemak"

DIA_KBD_VAR_uz="latin          uz_Latin
	crh            uz_CrimeanTatar_Q
	crh_f          uz_CrimeanTatar_F
	crh_alt        uz_CrimeanTatar_AltQ"

DIA_KBD_VAR_kr="kr104          kr_101/104"

DIA_KBD_VAR_ie="CloGaelach     ie_CloGaelach
	UnicodeExpert  ie_UnicodeExpert
	ogam           ie_Ogham
	ogam_is434     ie_Ogham_IS434"

DIA_KBD_VAR_pk="urd-crulp      pk_CRULP
	urd-nla        pk_NLA
	ara            pk_Arabic"

DIA_KBD_VAR_ng="igbo           ng_Igbo
	yoruba         ng_Yoruba
	hausa          ng_Hausa"

DIA_KBD_VAR_tm="alt            tm_Alt-Q"

DIA_KBD_VAR_ml="fr-oss         ml_Francais
	us-mac         ml_English_Macintosh
	us-intl        ml_English_International"
