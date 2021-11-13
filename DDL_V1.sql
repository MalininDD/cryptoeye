create database withdraw_tracker_prod
    with owner postgres;

create schema public;

comment on schema public is 'standard public schema';

alter schema public owner to postgres;

grant create, usage on schema public to public;

create table app_user
(
    id           serial
        constraint app_user_pk
            primary key,
    tg_id        bigint                not null,
    tg_username  text,
    watch        boolean default false not null,
    aml_access   boolean default false not null,
    count_access boolean default false
);

alter table app_user
    owner to postgres;

create unique index app_user_tg_id_uindex
    on app_user (tg_id);

create unique index app_user_tg_username_uindex
    on app_user (tg_username);

create table app_user_groups
(
    id       serial
        constraint app_user_groups_pk
            primary key,
    group_id integer
        constraint app_user_groups_groups_id_fk
            references groups
            on update restrict on delete restrict,
    user_id  integer
        constraint app_user_groups_app_user_id_fk
            references app_user
            on update restrict on delete restrict,
    owner    boolean default false
);

alter table app_user_groups
    owner to postgres;

create unique index app_user_groups_id_uindex
    on app_user_groups (id);


create table app_user_tracking_wallet
(
    id                     serial
        constraint app_user_tracking_wallet_pk
            primary key,
    user_id                integer
        constraint app_user_tracking_wallet_app_user_id_fk
            references app_user
            on update restrict on delete restrict,
    wallet_id              integer
        constraint app_user_tracking_wallet_tracking_wallet_id_fk
            references tracking_wallet
            on update cascade on delete cascade,
    name                   text,
    group_id               integer
        constraint app_user_tracking_wallet_groups_id_fk
            references groups
            on update restrict on delete restrict,
    from_tg_username_group text
        constraint app_user_tracking_wallet_app_user_tg_username_fk
            references app_user (tg_username)
            on update restrict on delete restrict
);

alter table app_user_tracking_wallet
    owner to postgres;


create table asset_list
(
    id      serial
        constraint asset_list_pk
            primary key,
    name    text not null,
    network text not null
);

alter table asset_list
    owner to postgres;


create table groups
(
    id         serial
        constraint groups_pk
            primary key,
    name       text    not null,
    created_by integer not null
        constraint groups_app_user_id_fk
            references app_user
            on update restrict on delete restrict
);

alter table groups
    owner to postgres;

create unique index groups_id_uindex
    on groups (id);


create table tracking_wallet
(
    id       serial
        constraint tracking_wallet_pk
            primary key,
    address  text    not null,
    asset_id integer not null
        constraint tracking_wallet_asset_list_id_fk
            references asset_list
            on update restrict on delete restrict
);

alter table tracking_wallet
    owner to postgres;




