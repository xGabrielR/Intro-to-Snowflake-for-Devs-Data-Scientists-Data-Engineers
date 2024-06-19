SELECT
    snowflake.cortex.summarize(content)
FROM reviews;

SELECT
    snowflake.cortext.sentiment(content),
    content
FROM reviews;

SELECT
    snowflake.cortex.extract_answer(
        review_content,
        'What dishes does this review mention?'
    )
FROM reviews;

SELECT
    snowflake.cortex.translate(content, 'en', 'de')
FROM reviews;
