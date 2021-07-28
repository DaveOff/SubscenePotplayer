/*
	subtitle search by Subscene
*/

// void OnInitialize()
// void OnFinalize()
// string GetTitle() 																-> get title for UI
// string GetVersion																-> get version for manage
// string GetDesc()																	-> get detail information
// string GetLoginTitle()															-> get title for login dialog
// string GetLoginDesc()															-> get desc for login dialog
// string GetUserText()																-> get user text for login dialog
// string GetPasswordText()															-> get password text for login dialog
// string ServerCheck(string User, string Pass) 									-> server check
// string ServerLogin(string User, string Pass) 									-> login
// void ServerLogout() 																-> logout
//------------------------------------------------------------------------------------------------
// string GetLanguages()															-> get support language
// string SubtitleWebSearch(string MovieFileName, dictionary MovieMetaData)			-> search subtitle bu web browser
// array<dictionary> SubtitleSearch(string MovieFileName, dictionary MovieMetaData)	-> search subtitle
// string SubtitleDownload(string id)												-> download subtitle
// string GetUploadFormat()															-> upload format
// string SubtitleUpload(string MovieFileName, dictionary MovieMetaData, string SubtitleName, string SubtitleContent)	-> upload subtitle

string API_URL = "https://faranevis.com";

array<array<string>> LangTable = 
{
    { "fa", "farsi" }
};

string GetTitle()
{
	return "Subscene";
}

string GetVersion()
{
	return "1";
}

string GetDesc()
{
	return "https://faranevis.com";
}

string GetLanguages()
{
	return LangTable[0][0];
}

string ServerCheck(string User, string Pass)
{
	string ret = HostUrlGetString(GetDesc());
	if (ret.empty()) return "fail";
	return "200 OK";
}

void AssignItem(dictionary &dst, JsonValue &in src, string dst_key, string src_key = "")
{
	if (src_key.empty()) src_key = dst_key;
	if (src[src_key].isString()) dst[dst_key] = src[src_key].asString();
	else if (src[src_key].isInt64()) dst[dst_key] = src[src_key].asInt64();	
}

array<dictionary> SubtitleSearch(string MovieFileName, dictionary MovieMetaData)
{
	string title = string(MovieMetaData["title"]);
	string year = string(MovieMetaData["year"]);
	array<dictionary> ret;
	string api = API_URL + "/api/desksub/search/" + HostUrlEncode(title + " (" + year + ")");
	string json = HostUrlGetString(api);
	JsonReader Reader;
	JsonValue Root;
	
	if (Reader.parse(json, Root) && Root.isArray())
	{
		JsonValue movies = Root;
		if (movies.isArray())
		{
			for (int i = 0, len = movies.size(); i < len; i++)
			{
				dictionary item;
				item["id"] = movies[i]['url'].asString();
				item["title"] = movies[i]['title'].asString();
				item["format"] = "srt";
				item["year"] = string(MovieMetaData["year"]);
				item["lang"] = 'fa';
				item["url"] = movies[i]['url'].asString();
				item["language"] = "Farsi";
				ret.insertLast(item);
			}
		}
	}
	return ret;
}

string SubtitleDownload(string download)
{
	return HostUrlGetString(download);
}
