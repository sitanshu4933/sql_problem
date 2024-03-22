/*
In the last 7 days, get a distribution of games (% of total games) based on the social interaction that is happening during the games. Please consider the following as the categories for getting the distribution:
� No Social Interaction ( No messages, emojis or gifts sent during the game) One sided interaction (Messages, emojis or gifts sent during the game by only one player)
� Both sided Interaction without custom_typed messages
Both sided interaction with custom_typed_messages from at least one player
Context: During a game, the users have the ability to socially interact with each other by sending custom typed messages, preloaded quick messages, emojis or game gifts. The sample entries for one of the games is provided below:-

Script:
CREATE TABLE user_interactions (
    user_id varchar(10),
    event varchar(15),
    event_date DATE,
    interaction_type varchar(15),
    game_id varchar(10),
    event_time TIME
);

-- Insert the data
INSERT INTO user_interactions 
VALUES
('abc', 'game_start', '2024-01-01', null, 'ab0000', '10:00:00'),
('def', 'game_start', '2024-01-01', null, 'ab0000', '10:00:00'),
('def', 'send_emoji', '2024-01-01', 'emoji1', 'ab0000', '10:03:20'),
('def', 'send_message', '2024-01-01', 'preloaded_quick', 'ab0000', '10:03:49'),
('abc', 'send_gift', '2024-01-01', 'gift1', 'ab0000', '10:04:40'),
('abc', 'game_end', '2024-01-01', NULL, 'ab0000', '10:10:00'),
('def', 'game_end', '2024-01-01', NULL, 'ab0000', '10:10:00'),
('abc', 'game_start', '2024-01-01', null, 'ab9999', '10:00:00'),
('def', 'game_start', '2024-01-01', null, 'ab9999', '10:00:00'),
('abc', 'send_message', '2024-01-01', 'custom_typed', 'ab9999', '10:02:43'),
('abc', 'send_gift', '2024-01-01', 'gift1', 'ab9999', '10:04:40'),
('abc', 'game_end', '2024-01-01', NULL, 'ab9999', '10:10:00'),
('def', 'game_end', '2024-01-01', NULL, 'ab9999', '10:10:00'),
('abc', 'game_start', '2024-01-01', null, 'ab1111', '10:00:00'),
('def', 'game_start', '2024-01-01', null, 'ab1111', '10:00:00'),
('abc', 'game_end', '2024-01-01', NULL, 'ab1111', '10:10:00'),
('def', 'game_end', '2024-01-01', NULL, 'ab1111', '10:10:00'),
('abc', 'game_start', '2024-01-01', null, 'ab1234', '10:00:00'),
('def', 'game_start', '2024-01-01', null, 'ab1234', '10:00:00'),
('abc', 'send_message', '2024-01-01', 'custom_typed', 'ab1234', '10:02:43'),
('def', 'send_emoji', '2024-01-01', 'emoji1', 'ab1234', '10:03:20'),
('def', 'send_message', '2024-01-01', 'preloaded_quick', 'ab1234', '10:03:49'),
('abc', 'send_gift', '2024-01-01', 'gift1', 'ab1234', '10:04:40'),
('abc', 'game_end', '2024-01-01', NULL, 'ab1234', '10:10:00'),
('def', 'game_end', '2024-01-01', NULL, 'ab1234', '10:10:00');

*/
--Solution
select game_id
,case 
	when COUNT(interaction_type)=0 then 'No Interaction' 
	when count(distinct case when interaction_type is not null then user_id end)=1 then 'One Sided Interaction' 
	when count(distinct case when interaction_type is not null then user_id end)=2 and
		count(distinct case when interaction_type='custom_typed' then user_id end)=0 then 'Both Sided Interaction without Custom_typed'
	when count(distinct case when interaction_type is not null then user_id end)=2 and
		count(distinct case when interaction_type='custom_typed' then user_id end)>=1 then 'Both Sided Interaction with Custom_typed'
	end as game_type
,COUNT(*)*100.0/(select COUNT(*) from user_interactions) as [%value]
from user_interactions
group by game_id

