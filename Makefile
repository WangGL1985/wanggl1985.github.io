.PHONY:all
all: deploy commit

.PHONY:deploy
deploy:
	hexo clean
	hexo g && gulp
	cd public; touch CNAME; echo "ccwangguoliang.com" > CNAME
	hexo d


.PHONY:commit
commit:
	./commit.sh

.PHONY:clean
clean:
	hexo clean
