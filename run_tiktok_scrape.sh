#!/bin/bash

# 检查是否提供了用户名参数
if [ -z "$1" ]; then
  echo "错误：请提供一个 TikTok 用户名作为参数。"
  echo "用法: $0 @username"
  exit 1
fi

# 要抓取的用户名，例如 @username
USERNAME=$1

# --- 核心命令 ---
# 脚本假设您在 yt-dlp 项目的根目录下执行
# 并且已经创建了虚拟环境，并应用了补丁 (git apply)

PYTHONPATH=. ./.venv/bin/python -m yt_dlp --dump-single-json --dateafter now-7days "https://www.tiktok.com/$USERNAME" | jq '{
    user_id: .uploader_id,
    user_nickname: .user_nickname,
    user_unique_id: .user_unique_id,
    user_signature: .user_signature,
    user_avatar: .user_avatar,
    user_verified: .user_verified,
    user_private_account: .user_private_account,
    user_create_time: .user_create_time,
    user_language: .user_language,
    user_follower_count: .user_follower_count,
    user_following_count: .user_following_count,
    user_total_likes: .user_total_likes,
    user_video_count: .user_video_count,
    entries: [
        .entries[] | {
            duration: .duration,
            title: .title,
            description: .description,
            timestamp: .timestamp,
            view_count: .view_count,
            like_count: .like_count,
            repost_count: .repost_count,
            comment_count: .comment_count,
            thumbnail: .thumbnail
        }
    ]
}'
