<x-app-layout>
    <x-slot name="header">index</x-slot>
    <h1>Blog Name</h1>
    <div class="user name">{{ Auth::user()->name }}</div>
        <div class='posts'>
        @foreach ($posts as $post)
            <h2 class='title'>
                <a href="/posts/{{ $post->id }}">{{ $post->title }}</a>
            </h2>
            <p class='body'>{{ $post->body }}</p>
            <!-- 以下を追記 -->
            <form action="/posts/{{ $post->id }}" id="form_{{ $post->id }}" method="post">
                @csrf
                @method('DELETE')
                <button type="button" onclick="deletePost({{ $post->id }})">delete</button> 
            </form>
            <a href="/categories/{{ $post->category->id }}">{{ $post->category->name }}</a>
        @endforeach
    </div>
    <div class='paginate'>
        {{ $posts->links() }}
    </div>
    <a href='/posts/create'>create</a>
    
    <script>
        function deletePost(id) {
            'use strict'
    
            if (confirm('削除すると復元できません。\n本当に削除しますか？')) {
                document.getElementById(`form_${id}`).submit();
            }
        }
    </script>    
</x-app-layout>
