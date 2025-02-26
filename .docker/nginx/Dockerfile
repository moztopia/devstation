FROM nginx:stable-alpine

# Create a new user group
# RUN addgroup --gid 1001 appgroup

# Create a new user and add it to the group
# RUN adduser --disabled-password --gecos '' --uid 1001 --gid 1001 appuser
# The above does not work because alpine uses the adduser method supplied by busybox
# RUN adduser --disabled-password -g '' -G appgroup -u 1001 appuser

# Set the new user as the default user
# USER appuser

RUN rm /etc/nginx/conf.d/default.conf
COPY default.conf /etc/nginx/conf.d/default.conf
