--- a/yt_dlp/extractor/tiktok.py
+++ b/yt_dlp/extractor/tiktok.py
@@ -1066,6 +1066,34 @@
 
         return None
 
+    def _get_extra_user_info(self, detail):
+        user_info = traverse_obj(detail, ('userInfo', 'user', {dict})) or {}
+        user_stats = traverse_obj(detail, ('userInfo', 'stats', {dict})) or {}
+        return {
+            'uploader_id': traverse_obj(user_info, ('id', {str})),
+            'user_nickname': traverse_obj(user_info, ('nickname', {str})),
+            'user_unique_id': traverse_obj(user_info, ('uniqueId', {str})),
+            'user_sec_uid': traverse_obj(user_info, ('secUid', {str})),
+            'user_signature': traverse_obj(user_info, ('signature', {str})),
+            'user_avatar': traverse_obj(user_info, ('avatarLarger', {url_or_none})),
+            'user_verified': traverse_obj(user_info, ('verified', {bool})),
+            'user_private_account': traverse_obj(user_info, ('privateAccount', {bool})),
+            'user_scomment_setting': traverse_obj(user_info, ('commentSetting', {int_or_none})),
+            'user_duet_setting': traverse_obj(user_info, ('duetSetting', {int_or_none})),
+            'user_stitch_setting': traverse_obj(user_info, ('stitchSetting', {int_or_none})),
+            'user_is_ad_virtual': traverse_obj(user_info, ('isADVirtual', {bool})),
+            'user_room_id': traverse_obj(user_info, ('roomId', {str})),
+            'user_unique_idModify_time': traverse_obj(user_info, ('uniqueIdModifyTime', {int_or_none})),
+            'user_tt_seller': traverse_obj(user_info, ('ttSeller', {bool})),
+            'user_download_setting': traverse_obj(user_info, ('downloadSetting', {int_or_none})),
+            'user_is_organizatio': traverse_obj(user_info, ('isOrganization', {int_or_none})),
+            'user_story_status': traverse_obj(user_info, ('UserStoryStatus', {int_or_none})),
+            'user_create_time': traverse_obj(user_info, ('createTime', {int_or_none})),
+            'user_language': traverse_obj(user_info, ('language', {str})),
+            'user_follower_count': traverse_obj(user_stats, ('followerCount', {int_or_none})),
+            'user_following_count': traverse_obj(user_stats, ('followingCount', {int_or_none})),
+            'user_total_likes': traverse_obj(user_stats, ('heartCount', {int_or_none})),
+            'user_video_count': traverse_obj(user_stats, ('videoCount', {int_or_none})),
+        }
+
     def _real_extract(self, url):
         user_name, sec_uid = self._match_id(url), None
         if re.fullmatch(r'MS4wLjABAAAA[\w-]{64}', user_name):
@@ -1084,6 +1112,9 @@
             elif video_count == 0:
                 raise ExtractorError('This account does not have any videos posted', expected=True)
             sec_uid = traverse_obj(detail, ('userInfo', 'user', 'secUid', {str}))
+
+            extra_user_data = self._get_extra_user_info(detail)
+
             if sec_uid:
                 fail_early = not traverse_obj(detail, ('userInfo', 'itemList', ...))
             else:
@@ -1096,7 +1127,11 @@
                 'from a video posted by this user, try using "tiktokuser:channel_id" as the '
                 'input URL (replacing `channel_id` with its actual value)', expected=True)
 
-        return self.playlist_result(self._entries(sec_uid, user_name, fail_early), sec_uid, user_name)
+        return self.playlist_result(
+            self._entries(sec_uid, user_name, fail_early),
+            sec_uid, user_name,
+            **filter_dict(extra_user_data if 'extra_user_data' in locals() else {})
+        )
 
 
 class TikTokBaseListIE(TikTokBaseIE):  # XXX: Conventionally, base classes should end with BaseIE/InfoExtractor
