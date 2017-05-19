FROM ruby:2.4
WORKDIR /usr/src/app
COPY Gemfile /usr/src/app
COPY Gemfile.lock /usr/src/app
RUN bundle install
ADD . /usr/src/app
EXPOSE 4567
ENV RACK_ENV=test
CMD ["rake"]