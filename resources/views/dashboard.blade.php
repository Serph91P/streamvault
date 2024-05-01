<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
            {{ __('Dashboard') }}
        </h2>
    </x-slot>

    <div class="py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg">
                <div class="p-6 text-gray-900 dark:text-gray-100">
                    {{ __("You're logged in!") }}
                    <div class="mt-6">
                        <h3 class="text-lg leading-6 font-medium text-gray-900">Streamer Status</h3>
                        <div class="mt-4">
                            @forelse($streamers as $streamer)
                            <p>{{ $streamer->name }} - {{ $streamer->stream_url }}</p>
                            @empty
                            <p>No streamers found.</p>
                            @endforelse
                            <a href="{{ route('streamers.create') }}" class="mt-4 inline-flex items-center px-4 py-2 bg-blue-500 hover:bg-blue-700 text-white font-medium rounded-md">
                                Add Streamer
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</x-app-layout>