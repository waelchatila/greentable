[![Build Status](https://travis-ci.org/waelchatila/greentable.svg?branch=master)](https://travis-ci.org/waelchatila/greentable)

[![Coverage Status](https://coveralls.io/repos/waelchatila/greentable/badge.png)](https://coveralls.io/r/waelchatila/greentable)

Greentable
==========

Greentable produces HTML tables from an array without you having to deal with any HTML elements.
Greentable is an declarative approach to HTML tables and adds additional export (csv,xls,pdf,xml) features.

Please note that the export module is still under development.

Tested on rails 3.2, using ruby 1.9.3

## Installation
```ruby
gem 'greentable'
```

## Usage
To produce a table from an array of elements, do the following in a view:

```haml
=greentable(users) do |gt,user|
  - gt.col('NAME') do
    =user.name
  - gt.col('EMAIL') do
    =user.email
```

which will produce the following html:

```html
<table>
    <thead>
        <tr>
          <th>NAME</th>
          <th>EMAIL</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Joe Ruby</td>
            <td>jruby@example.com</td>
        </tr>
        <tr>
            <td>Donald Rails</td>
            <td>drails@example.com</td>
        </tr>
    </tbody>
</table>
```

## Options

Both greentable and greentable.col may be called with an optional hash

```haml
=greentable(array, class: 'table_class') do |gt, el|
  -gt.col('col0', th: {class: 'th_class'}) do
    =el.col0
  -gt.col('col1', td: {class: 'td_class'}) do
    =el.col1
```

will produce

```html
<table class="table_class"">
    <thead>
        <tr>
            <th class="th_class">col0</th>
            <th>col1</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>...</td>
            <td class="td_class">...</td>
        </tr>
    </tbody>
</table>
```

A comprehensive example:

```haml
=greentable(array, class: 'a aa', style: 'b:c', tr: {class: 'd'}, th: {onclick: 'e();'}, td: {class: 'f', 'data-target' => 'g'} ) do |gt, el|
  -gt.col('col0', class: 'h', th: {class: 'i'}) do
    =el.col0
  -gt.col('col1', td: {class: 'j'}) do
    =el.col1
```

will produce

```html
<table class="a aa" style="b:c">
    <thead>
        <tr class="d">
            <th onclick="e();" class="h i ee">col0</th>
            <th onclick="e();" class="ee">col1</th>
        </tr>
    </thead>
    <tbody>
        <tr class="d">
            <td data-target="f" class="h ff">0</td>
            <td data-target="f" class="j ff">0</td>
        </tr>
    </tbody>
</table>
```

If you need column names or options to be dynamic, you can use procs:

```haml
=greentable(years) do |gt,year|
  -gt.col('Year') do
    =year.to_s
  -4.times do |week|
    -gt.col(Proc.new{ week % 2 == 0 ? 'An even week' : 'An odd week' }, td: {style: Proc.new{ year % 2 == 1 ? 'background-color:red' : nil }} ) do
      =week
```

will produce

```html
<table>
    <thead>
        <tr>
          <th>Year</th>
          <th>An even week</th>
          <th>An odd week</th>
          <th>An even week</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>2013</td>
            <td>0</td>
            <td style='background-color:red'>1</td>
            <td>2</td>
            <td style='background-color:red'>3</td>
        </tr>
        <tr>
            <td>2014</td>
            <td>0</td>
            <td style='background-color:red'>1</td>
            <td>2</td>
            <td style='background-color:red'>3</td>
        </tr>
        ...
    </tbody>
</table>
```


## Global Defaults
You can configure global defaults for all your greentables.

In config/initializers/greentable.rb

```ruby
Greentable.configure do |config|
  config.defaults = {class: 'myTableClass', tr: {class: 'myTrClass'}, th: {style: 'cursor:pointer'}, td: {class: 'pi', onclick: 'alert(3.14159265359)'}}
end
```

and in some view:

```erb
<%= greentable([3.14]) do |gt,element| %>
    <%  gt.col('First Column') do %>
        <%= element %>
    <% end %>
<% end %>
```

will produce

```html
<table class='myTableClass'>
    <thead>
        <tr class='myTrClass'>
          <th style='cursor:pointer'>First Column</th>
        </tr>
    </thead>
    <tbody>
        <tr class='myTrClass'>
            <td class='pi' onclick='alert(3.14159265359)'>3.14</td>
        </tr>
    </tbody>
</table>
```

## Green Export

Greentable enables you to export your greentable data for download in various formats seamlessly by a rack middleware.


[export still under development. more soon]


