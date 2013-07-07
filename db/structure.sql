CREATE TABLE "comments" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "description" text, "user_id" integer, "idea_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "ideas" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar(255), "description" varchar(255), "positive" integer, "negative" integer, "created_date" date, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "user_id" integer, "status" integer);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar(255), "email" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "provider" varchar(255), "uid" varchar(255), "oauth_token" varchar(255), "oauth_expires_at" datetime, "image" varchar(255));
CREATE TABLE "votes" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "like" boolean, "user_id" integer, "idea_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE INDEX "index_comments_on_idea_id" ON "comments" ("idea_id");
CREATE INDEX "index_comments_on_user_id" ON "comments" ("user_id");
CREATE INDEX "index_ideas_on_user_id" ON "ideas" ("user_id");
CREATE INDEX "index_votes_on_idea_id" ON "votes" ("idea_id");
CREATE INDEX "index_votes_on_user_id" ON "votes" ("user_id");
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20130513155100');

INSERT INTO schema_migrations (version) VALUES ('20130628162508');

INSERT INTO schema_migrations (version) VALUES ('20130628162843');

INSERT INTO schema_migrations (version) VALUES ('20130630010630');

INSERT INTO schema_migrations (version) VALUES ('20130703004451');

INSERT INTO schema_migrations (version) VALUES ('20130703022636');

INSERT INTO schema_migrations (version) VALUES ('20130703175909');

INSERT INTO schema_migrations (version) VALUES ('20130704160022');