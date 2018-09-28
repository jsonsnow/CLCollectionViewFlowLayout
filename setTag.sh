#!/bin/bash



#!/bin/bash
	
	tagName=$(cat CLCollectionViewFlowLayout.podspec |awk '{if(NR==19){print $3}}')
	echo "原标签为$tagName"

	read -t 30 -p "请输入标签名(新标签需要大于原标签):" tag
	echo "新标签名为$tag"

	sed -i '' "s/$tagName/\"$tag\"/g" CLCollectionViewFlowLayout.podspec
	sleep 2s

	read -p "git准备提交本地变更，请确认提交本地变更，按任意键继续"

	git add --all 
	git commit -m "commit new tag" 
	git push -u origin master
	echo "提交git远程仓库完成！"


	sleep 2s
	git tag $tag
	sleep 1s
	git push origin $tag

	echo "提交远程标签完成！"

	sleep 2s
	pod trunk push --verbose --allow-warnings
	echo "更新索引完成！"

