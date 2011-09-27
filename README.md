The EventSource HQ Gem
======================

Make sure you have an EventSource HQ account.

The eshq gem will use the following environment variables:

    ESHQ_URL
    ESHQ_KEY
    ESHQ_SECRET

To create a new socket that the client-side javascript library can use
to connect with:

    ESHQ.open(:channel => "your-channel")

To send a message to a channel:

    ESHQ.send(:channel => "your-channel", :data => "raw message data")
