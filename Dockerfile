FROM ruby:2.4
WORKDIR /usr/src/app
ADD . /usr/src/app
RUN bundle install
EXPOSE 4567
CMD ["rake"]