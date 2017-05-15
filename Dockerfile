FROM ruby:2.4
COPY . /usr/src/app
WORKDIR /usr/src/app
RUN bundle install
EXPOSE 4567
CMD ["rake"]