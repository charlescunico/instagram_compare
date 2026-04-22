## PROMPTS.md

**Tool:** Claude Sonnet 4.6
**Date:** 2026-04-22 17:51
**Prompt:** "write a Ruby script that reads 2 JSON files, usually named following.json and followers_1.json. These files are obtained from Instagram Information Export. After loading the information from the two files, must print two lists: one list containing the name and respective link of the profiles who is in following but not in followers_1. The other list containing the name and respective link of the profiles who is in followers_1 but not in following."
**Output file:** `instagram_compare.rb`

**Tool:** Claude Sonnet 4.6
**Date:** 2026-04-22 18:32
**Prompt:** "the followers_1.json part appears to be correct, showing the right count. But there is an error with the following.json part, it's not correct because it shows 0 results. Fix it"
**Output file:** `instagram_compare.rb`

**Tool:** Claude Sonnet 4.6
**Date:** 2026-04-22 18:48
**Prompt:** "it still don't work. I will paste an example of the correct structure of the JSON files. Fix the code based on this:

followers_1.json
[
  {
    "title": "",
    "media_list_data": [
      
    ],
    "string_list_data": [
      {
        "href": "https://www.instagram.com/john",
        "value": "john",
        "timestamp": 1776874396
      }
    ]
  }
]

following.json
{
  "relationships_following": [
    {
      "title": "john",
      "string_list_data": [
        {
          "href": "https://www.instagram.com/_u/john",
          "timestamp": 1776874403
        }
      ]
    }
  ]
}"
**Output file:** `instagram_compare.rb`
