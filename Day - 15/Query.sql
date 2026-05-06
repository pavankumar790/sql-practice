with n as
(
    -- Combine users and events tables
    -- to get all activity details together
    select
        u.user_id,
        u.name,
        u.join_date,
        e."type",
        e.access_date
    from users u
    left join events e
        on u.user_id = e.user_id
),


a as
(
    -- Extract only Music users
    select *
    from n
    where n."type" = 'Music'
),


b as
(
    -- Extract only Prime subscription users
    select *
    from n
    where n."type" = 'P'
),


c as
(
    -- Match Music activity with Prime subscription
    -- for the same user
    select
        a.user_id,
        a.join_date,
        a."type" as Music_,
        a.access_date as Music_date,
        b."type" as P_,
        b.access_date as P_date

    from a

    left join b
        on a.user_id = b.user_id
),


d as
(
    -- Keep only users who:
    -- 1. Purchased Prime AFTER Music usage
    -- 2. Purchased Prime within 30 days of signup

    select *
    from c

    where P_date >= Music_date
    and P_date <= join_date + interval '30 days'
),


x as
(
    -- Total number of Music users
    select
        1 as index,
        count(distinct user_id) as music_users
    from a
),


y as
(
    -- Total number of converted users
    -- (Music -> Prime within 30 days)
    select
        1 as index,
        count(distinct user_id) as req_users
    from d
)


-- Final conversion ratio
select
    x.music_users,
    y.req_users,

    round(
        y.req_users * 1.0 / x.music_users,
        2
    ) as conv_ratio

from x

left join y
    on x.index = y.index;