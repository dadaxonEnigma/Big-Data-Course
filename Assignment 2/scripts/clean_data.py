import pandas as pd
import numpy as np

def load_data():
    messages_df = pd.read_csv(r'C:\Users\User\Desktop\code\scripts\messages.csv',low_memory=False)
    friends_df = pd.read_csv(r'C:\Users\User\Desktop\code\scripts\friends.csv')
    clients_purchase_df = pd.read_csv(r'C:\Users\User\Desktop\code\scripts\client_first_purchase_date.csv')
    events_df = pd.read_csv(r'C:\Users\User\Desktop\code\scripts\events.csv')
    campaigns_df = pd.read_csv(r'C:\Users\User\Desktop\code\scripts\campaigns.csv')
    
    return messages_df, friends_df, clients_purchase_df, events_df, campaigns_df

# Clean messages_df
def clean_messages(messages_df):
    messages_df = messages_df.drop('category',axis=1)
    
    messages_df['platform'] = messages_df['platform'].fillna(messages_df['platform'].mode()[0])
    messages_df['email_provider'] = messages_df['email_provider'].fillna(messages_df['email_provider'].mode()[0])

    datetime_columns = [
        "sent_at", "opened_first_time_at", "opened_last_time_at",
        "clicked_first_time_at", "clicked_last_time_at", "unsubscribed_at",
        "hard_bounced_at", "soft_bounced_at", "complained_at",
        "blocked_at", "purchased_at", "created_at", "updated_at"
    ]
    
    for col in datetime_columns:
        messages_df[col] = pd.to_datetime(messages_df[col], errors="coerce")
    def fillna_group_median(df, group_col, target_col):
        return df[target_col].fillna(df.groupby(group_col)[target_col].transform("median"))

    bool_columns = [
        'is_opened', 'is_clicked', 'is_unsubscribed', 'is_hard_bounced',
        'is_soft_bounced', 'is_complained', 'is_blocked', 'is_purchased'
    ]
    
    for col in bool_columns:
        messages_df[col] = messages_df[col].replace({'F': False, 'T': True}).astype(bool)
        messages_df[col] = messages_df[col].fillna(False)
    
    for col in ["opened_first_time_at", "opened_last_time_at"]:
        messages_df[col] = fillna_group_median(messages_df, "campaign_id", col)
        messages_df[col] = messages_df[col].fillna(messages_df["sent_at"]) 

    # Check, for  opened_last_time_at >= opened_first_time_at
    mask_opened_invalid = messages_df["opened_last_time_at"] < messages_df["opened_first_time_at"]
    messages_df.loc[mask_opened_invalid, "opened_last_time_at"] = messages_df.loc[mask_opened_invalid, "opened_first_time_at"]

    # Filling with median
    messages_df['created_at'] = messages_df['created_at'].fillna(messages_df['created_at'].median())
    messages_df['updated_at'] = messages_df['updated_at'].fillna(messages_df['updated_at'].median())

    messages_df['clicked_first_time_at'] = messages_df['clicked_first_time_at'].fillna(messages_df['opened_first_time_at'])
    messages_df['clicked_last_time_at'] = messages_df['clicked_last_time_at'].fillna(messages_df['opened_last_time_at'])

    messages_df['unsubscribed_at'] = messages_df['unsubscribed_at'].fillna(messages_df['clicked_last_time_at'])
    messages_df['hard_bounced_at'] = messages_df['hard_bounced_at'].fillna(messages_df['clicked_last_time_at'])
    messages_df['soft_bounced_at'] = messages_df['soft_bounced_at'].fillna(messages_df['clicked_last_time_at'])

    messages_df['complained_at'] = messages_df['complained_at'].fillna(messages_df['clicked_first_time_at'])
    messages_df['blocked_at'] = messages_df['blocked_at'].fillna(messages_df['clicked_first_time_at'])
    messages_df['purchased_at'] = messages_df['purchased_at'].fillna(messages_df['clicked_first_time_at'])

    
    return messages_df

# Cleaning friends_df
def clean_friends(friends_df):
    # drop duplicates
    friends_df = friends_df.drop_duplicates(subset=['friend1', 'friend2'], keep='first')
    return friends_df

# Clean clients_purchase_df
def clean_clients_purchase(clients_purchase_df):
    clients_purchase_df['first_purchase_date'] = pd.to_datetime(clients_purchase_df['first_purchase_date'], errors='coerce')
    return clients_purchase_df

# Clean events_df
def clean_events(events_df):
    # Creating a dictionary to match the brand and the most frequent category
    brand_category_mapping = events_df.dropna(subset=['category_code']).groupby('brand')['category_code'].agg(lambda x: x.mode()[0]).to_dict()
    # Fill in the missing values based on the brand
    events_df['category_code'] = events_df['category_code'].fillna(events_df['brand'].map(brand_category_mapping))
    # Fill in the remaining gaps with the most frequent category
    events_df['category_code'] = events_df['category_code'].fillna('electronics.smartphone')
    
    # Creating a dictionary to match category_code and the most frequent brand
    category_brand_mapping = events_df.dropna(subset=['brand']).groupby('category_code')['brand'].agg(lambda x: x.mode()[0]).to_dict()
    # Filling in missing values based on category_code
    events_df['brand'] = events_df['brand'].fillna(events_df['category_code'].map(category_brand_mapping))
    # Fill in the remaining gaps with the most frequent brand
    events_df['brand'] = events_df['brand'].fillna('samsung')
    events_df['event_time'] = pd.to_datetime(events_df['event_time'], errors='coerce')
    
    return events_df

# Clean campaigns_df
def clean_campaigns(campaigns_df):
    campaigns_df[['ab_test', 'is_test']] = campaigns_df[['ab_test', 'is_test']].astype('boolean').fillna(False)
    
    original_campaigns_df = campaigns_df.copy()
    most_common_topics = campaigns_df.groupby('campaign_type')['topic'].agg(lambda x: x.mode()[0])
    campaigns_df['topic'] = campaigns_df.apply(
        lambda row: most_common_topics[row['campaign_type']] if pd.isna(row['topic']) else row['topic'],
        axis=1
    )
    
    campaigns_df['total_count'] = campaigns_df['total_count'].fillna(campaigns_df['total_count'].median())
    campaigns_df["warmup_mode"] = False
    campaigns_df.loc[campaigns_df["topic"] == "welcome campaign", "warmup_mode"] = True

    campaigns_df['subject_length'] = campaigns_df.groupby('channel')['subject_length'].transform(lambda x: x.fillna(x.median()))
    campaigns_df['subject_length'] = campaigns_df['subject_length'].fillna(campaigns_df['subject_length'].median())
    
    subject_columns = [
        'subject_with_personalization', 'subject_with_deadline', 'subject_with_emoji',
        'subject_with_bonuses', 'subject_with_discount', 'subject_with_saleout'
    ]
    
    campaigns_df[subject_columns] = campaigns_df[subject_columns].astype('boolean').fillna(False)
    
    campaigns_df.loc[campaigns_df['campaign_type'].isin(['bulk', 'transactional']), 'position'] = 0
    campaigns_df['position'] = campaigns_df.groupby('campaign_type')['position'].transform(lambda x: x.fillna(x.median()))
    
    campaigns_df['hour_limit'] = campaigns_df.groupby('channel')['subject_length'].transform(lambda x: x.fillna(x.median()))
    campaigns_df['started_at'] = pd.to_datetime(campaigns_df['started_at'], errors='coerce')
    campaigns_df['finished_at'] = pd.to_datetime(campaigns_df['finished_at'], errors='coerce')
    
    valid_campaigns = campaigns_df.dropna(subset=['started_at', 'finished_at'])
    avg_duration = (valid_campaigns['finished_at'] - valid_campaigns['started_at']).mean()

    mask_started_na = campaigns_df['started_at'].isna()
    campaigns_df.loc[mask_started_na, 'started_at'] = campaigns_df.loc[mask_started_na, 'finished_at'] - avg_duration

    mask_finished_na = campaigns_df['finished_at'].isna()
    campaigns_df.loc[mask_finished_na, 'finished_at'] = campaigns_df.loc[mask_finished_na, 'started_at'] + avg_duration
    
    # Filling in rows where both values are omitted
    mask_both_na = campaigns_df['started_at'].isna() & campaigns_df['finished_at'].isna()
    if mask_both_na.any():
        avg_started = valid_campaigns['started_at'].mean()
        campaigns_df.loc[mask_both_na, 'started_at'] = avg_started
        campaigns_df.loc[mask_both_na, 'finished_at'] = avg_started + avg_duration
    return campaigns_df

def main():
    messages_df, friends_df, clients_purchase_df, events_df, campaigns_df = load_data()
    
    messages_df = clean_messages(messages_df)
    friends_df = clean_friends(friends_df)
    clients_purchase_df = clean_clients_purchase(clients_purchase_df)
    events_df = clean_events(events_df)
    campaigns_df = clean_campaigns(campaigns_df)
    
    messages_df_sample = messages_df.sample(n=1000000, random_state=42)
    
    messages_df_sample.to_csv('cleaned_messages.csv', index=False)
    friends_df.to_csv('friends_cleaned.csv', index=False)
    clients_purchase_df.to_csv('clients_purchase_cleaned.csv', index=False)
    events_df.to_csv('events_cleaned.csv', index=False)
    campaigns_df.to_csv('campaigns_cleaned.csv', index=False)
    
    return messages_df, friends_df, clients_purchase_df, events_df, campaigns_df

if __name__ == "__main__":
    messages_df, friends_df, clients_purchase_df, events_df, campaigns_df = main()
    print("All datasets cleaned successfully!")
