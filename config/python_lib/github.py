import emoji
from f.password import get_pass
GITHUB_TOKEN = get_pass("gh/ghapi-pat")
print("==== TOKEN HERE ====")
print(GITHUB_TOKEN)
from ghapi.all import GhApi, pages, paged
api = GhApi(token=GITHUB_TOKEN)

def get_raw_stars():
    # https://docs.github.com/en/rest/activity/starring#alternative-response-with-star-creation-timestamps-1
    # application/vnd.github.v3+json -> application/vnd.github.star+json -----> so github api responds back with star creation timestamps
    api.headers["Accept"] = "application/vnd.github.star+json"
    stars_first_page  = api.activity.list_repos_starred_by_authenticated_user()
    raw_stars = pages(api.activity.list_repos_starred_by_authenticated_user, api.last_page()).concat()
    # because of the headers modification, the github API response comes back in format:
    # [{'starred_at': date, 'repo': { all_repo_kv_pairs }}, {'starred_at': date, 'repo': { all_repo_kv_pairs}}]
    
    # because of above, the below modifies the returned dict so the data is not double nested, like this:
    # [{'starred_at': date, repo_kv_pair_1: x }, {'starred_at': date, repo_kv_pair_1: x}]
    stars = []
    for raw_star in raw_stars:
        raw_star["repo"]["starred_at"] = raw_star["starred_at"]
        stars.append(raw_star["repo"])
    
    # for print debugging - all kv pairs for the first star
    # for star in stars:
    #     print(star)
    #     for [k, v] in star.items():
    #         print(k, v)
    #     break
    # exit()

    return stars


def get_star_urls(owner_name):
    """returns a list of all starred github repos"""
    stars = []
    raw_stars = get_raw_stars()
    for star in raw_stars:
        if owner_name:
            stars.append(star["full_name"].lower())
        else:
            stars.append("https://github.com/" + star["full_name"].lower())
    return stars



def get_org(org):
        """Gets all repos under an organization. Used for get_config *"""
        """['owner_name', 'owner_name']"""
        repos = paged(api.repos.list_for_org, org=org)
        org_repos = []
        for page in repos:
            for repo in page:
                org_repos.append(repo["full_name"].lower())
        return org_repos


def star_raise_error(full_name):
    try: 
        star_repo(full_name, True)
    except Exception as e:
        raise Exception(e)




def star(full_name):
    star_repo(full_name, False)

def star_repo(full_name, raise_error):
        if full_name.startswith("https://github.com/"):
            full_name = full_name.replace("https://github.com/", "")

        owner_name = full_name.split("/")
        owner = owner_name[0]
        name = owner_name[1]
        try:
            api.activity.star_repo_for_authenticated_user(owner=owner, repo=name)
        except Exception as e: 
            str = f" Exception Encountered when starring: {full_name} - does the repo exist on github?"
            print(str, " - ", e)
            if raise_error:
                raise Exception(e)
            else:
                exit()
        else:
            print(emoji.emojize(":star:") + " " + full_name)

def unstar(self, repo):
    # this function is only called from manual
    try:
        api.activity.unstar_repo_for_authenticated_user(owner=repo["owner"], repo=repo["name"])
    except Exception as e: 
        print(e)
        exit()
    else:
        print("unstarred --> " + repo["owner"] + "/" + repo["name"])
